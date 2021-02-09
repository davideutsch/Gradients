//
//  SavedGradientsViewController.swift
//  Gradients
//
//  Created by David Deutsch on 06.12.20.
//

import UIKit

class SavedGradientsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let minimumCellSize: CGFloat = 150.0
    let cellSpacing: CGFloat = 16.0
    
    var savedGradients: [Gradient]? 
    
    var currentActiveControlOnGradient = 0
    
    let exportSlideVC = ExportSlideViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(SavedGradientCell.nib(), forCellWithReuseIdentifier: SavedGradientCell.identifier)
        collectionView.register(GradientCVHeader.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GradientCVHeader.identifier)
        
        setCellInsets()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //loadSavedGradients
        savedGradients = RealmHelper.getAllSavedGradients()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //reloadSavedGradients
        self.savedGradients = RealmHelper.getAllSavedGradients()
        
        //updateCollectionView
        self.collectionView.reloadData()
    }
    
    func setCellInsets() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView!.collectionViewLayout = layout
    }
}

//MARK: - UICollectionViewDelegate

extension SavedGradientsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentActiveControlOnGradient = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GradientCVHeader.identifier, for: indexPath) as! GradientCVHeader
            cell.configure(text: "Saved Gradients")
            return cell
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 47.0)
    }
}

//MARK: - UICollectionViewDataSource

extension SavedGradientsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let savedGradients = savedGradients {
            return savedGradients.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedGradientCell.identifier, for: indexPath)
            as! SavedGradientCell
                
        if let savedGradients = savedGradients {
            let currentGradient = savedGradients[indexPath.row]
            
            cell.configure(with: savedGradients[indexPath.row], active: (currentActiveControlOnGradient == indexPath.row))
            
            cell.editBtnPressed = { () in
                self.changeToCreateViewController(gradient: currentGradient)
            }
            
            cell.deleteBtnPressed = { () in
                RealmHelper.deleteGradientById(id: savedGradients[indexPath.row].id)
                
                //reloadSavedGradients
                self.savedGradients = RealmHelper.getAllSavedGradients()
                
                //updateCollectionView
                collectionView.reloadData()
            }
            
            cell.exportBtnPressed = { () in
                self.exportSlideVC.modalPresentationStyle = .custom
                self.exportSlideVC.transitioningDelegate = self
                
                self.exportSlideVC.gradient = currentGradient
                self.present(self.exportSlideVC, animated: true, completion: nil)
            }
        }
        
        return cell
    }
    
    func changeToCreateViewController(gradient: Gradient){
        if let viewControllers = self.tabBarController?.viewControllers {
            
            let createViewController = viewControllers[0] as! CreateViewController
            createViewController.currentGradient = Gradient(direction: gradient.direction, colors: gradient.colors, id: gradient.id)
            createViewController.updateGradientView()
            createViewController.directionButton.setImage(createViewController.currentGradient.direction.arrowImage(), for: .normal)
            self.tabBarController?.selectedIndex = 0
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate

extension SavedGradientsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SavedGradientsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = getCellWidth(minimalWidth: minimumCellSize )
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func getCellWidth(minimalWidth: CGFloat) -> CGFloat{
        let viewWidth = collectionView.frame.size.width
        
        let cellsPerRow = Int((viewWidth - cellSpacing) / (minimalWidth + cellSpacing))
        let cellWidth = ((viewWidth - cellSpacing) / CGFloat(cellsPerRow)) - cellSpacing
        
        return cellWidth
    }
}

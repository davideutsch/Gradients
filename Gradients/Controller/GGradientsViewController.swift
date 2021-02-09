//
//  GlobalGradientsViewController.swift
//  Gradients
//
//  Created by David Deutsch on 05.12.20.
//

import UIKit

class GGradientsViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let minimumCellSize: CGFloat = 150.0
    let cellSpacing: CGFloat = 16.0
    
    var savedGradients: [Gradient] = []
    
    var currentActiveControlOnGradient = 0
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(reloadGlobalGradients), for:  .valueChanged)
        return refreshControl
    }()
    
    let firestore = FirebaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(GGradientCell.nib(), forCellWithReuseIdentifier: GGradientCell.identifier)
        collectionView.register(GradientCVHeader.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GradientCVHeader.identifier)
        
        setCellInsets()
        
        collectionView.delegate = self
        collectionView.dataSource = self 
        
        collectionView.alwaysBounceVertical = true;
        collectionView.refreshControl = refresher
        
        firestore.getGradients(completion: { (gradients) in
            self.savedGradients = gradients
            self.collectionView.reloadData()
        })
    }
    
    @objc func reloadGlobalGradients(){
        firestore.getGradients { (gradients) in
            self.savedGradients = gradients
            let deadline = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.refresher.endRefreshing()
                self.collectionView.reloadData()
            }
        }
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

extension GGradientsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentActiveControlOnGradient = indexPath.row
        self.collectionView.reloadData()
    }
    
    //load header for collectionview
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GradientCVHeader.identifier, for: indexPath) as! GradientCVHeader
            cell.configure(text: "Global Gradients")
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

extension GGradientsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGradients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GGradientCell.identifier, for: indexPath)
            as! GGradientCell
        
        let saved = RealmHelper.checkIfGradientExists(self.savedGradients[indexPath.row].id)
        cell.configure(with: savedGradients[indexPath.row],saved: saved, active: (currentActiveControlOnGradient == indexPath.row))
        
        cell.archiveBtnPressed = { () in
            let currentGradient = self.savedGradients[indexPath.row]
            RealmHelper.saveGradient(Gradient(direction: currentGradient.direction, colors: currentGradient.colors, id: currentGradient.id))
            self.firestore.likeGradient(uuid: currentGradient.id)
            self.collectionView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == savedGradients.count - 1 {
            // we are at last cell load more content
            firestore.getMoreDocuments { (gradients) in
                if gradients.count != 0 {
                    gradients.forEach { (gradient) in
                        self.savedGradients.append(gradient)
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension GGradientsViewController: UICollectionViewDelegateFlowLayout {
    // margin and paddign between each cell
    
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



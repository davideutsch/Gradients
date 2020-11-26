//
//  GradientsCollectionViewController.swift
//  Gradients
//
//  Created by David Deutsch on 23.11.20.
//

import UIKit

class GradientsCollectionViewController: UICollectionViewController {
    
    let minimumCellSize: CGFloat = 150.0
    let maximumCellSize: CGFloat = 250.0
    
    let cellSpacing: CGFloat = 16.0
    
    let savedGradients: [Gradient] = [
        Gradient(direction: Direction.TOPTOBOTTOM, colors: ["#ff6f00","#ffdd00"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#0014FF","#00E2FF"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#FF4500","FFD800"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#0014FF","#00E2FF"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.TOPTOBOTTOM, colors: ["#ff6f00","#ffdd00"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#0014FF","#00E2FF"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#FF4500","FFD800"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#0014FF","#00E2FF"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.TOPTOBOTTOM, colors: ["#ff6f00","#ffdd00"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#0014FF","#00E2FF"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#FF4500","FFD800"].map({ColorHelper.hexStringToUIColor(hex: $0)})),
        Gradient(direction: Direction.LEFTTORIGHT, colors: ["#0014FF","#00E2FF"].map({ColorHelper.hexStringToUIColor(hex: $0)}))
    ]
    
    let exportSlideVC = ExportSlideViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellInsets()
        
        collectionView.register(UINib(nibName: "GradientCell", bundle: nil), forCellWithReuseIdentifier: "GradientCell")
    }
    
    func setCellInsets() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        collectionView!.collectionViewLayout = layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGradients.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        let currentGradient = savedGradients[indexPath.row]
        
        if let gradientCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GradientCell", for: indexPath) as? GradientsCollectionViewCell  {
            
            gradientCell.editBtnPressed = {
                () in
                self.changeToCreateViewController(gradient: currentGradient)
            }
            
            gradientCell.deleteBtnPressed = {
                () in
                print("deleteBtn was pressed")
            }
            
            gradientCell.exportBtnPressed = {
                () in
                self.exportSlideVC.modalPresentationStyle = .custom
                self.exportSlideVC.transitioningDelegate = self
                
                self.exportSlideVC.gradient = currentGradient
                self.present(self.exportSlideVC, animated: true, completion: nil)
            }
            
            gradientCell.clearBtnPressed = {
                () in
                print("clearBtn was pressed")
            }
            
            gradientCell.configure(gradient: currentGradient)
            
            cell = gradientCell
        }
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Test:")
    }
    
    func changeToCreateViewController(gradient: Gradient){
        if let viewControllers = self.tabBarController?.viewControllers {
            
            let createViewController = viewControllers[0] as! CreateViewController
            createViewController.currentGradient = gradient
            createViewController.updateGradientView()
            
            self.tabBarController?.selectedIndex = 0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return cellSpacing
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return cellSpacing
//    }
}

extension GradientsCollectionViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension GradientsCollectionViewController: UICollectionViewDelegateFlowLayout {
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

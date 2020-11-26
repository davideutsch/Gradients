//
//  GradientsCollectionViewCell.swift
//  Gradients
//
//  Created by David Deutsch on 23.11.20.
//

import UIKit

class GradientsCollectionViewCell: UICollectionViewCell {
    
    var deleteBtnPressed: (()->())?
    var editBtnPressed: (()->())?
    var exportBtnPressed: (()->())?
    var clearBtnPressed: (()->())?

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    
    @IBOutlet weak var gradientView: UIView!
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(gradient: Gradient){
        setGradientBackground(gradient)
        setGradientCornerRadiusAndShadow()
        setBtnStyle()
    }
    
    func setBtnStyle() {
        let buttonWidth = CGFloat(Int((bounds.size.width / 2) - 20))
        
        deleteBtn.setCircleBackground(width: buttonWidth)
        deleteBtn.setTitle("", for: .normal)
        deleteBtn.setImage(getUIImageOfBtnString(name: "trash.fill"), for: .normal)
        
        editBtn.setCircleBackground(width: buttonWidth)
        editBtn.setTitle("", for: .normal)
        editBtn.setImage(getUIImageOfBtnString(name: "pencil"), for: .normal)

        exportBtn.setCircleBackground(width: buttonWidth)
        exportBtn.setTitle("", for: .normal)
        exportBtn.setImage(getUIImageOfBtnString(name: "arrowshape.turn.up.right.fill"), for: .normal)
    }
    
    func setGradientBackground(_ gradient: Gradient) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        if gradient.colors.count == 1 {
            let singleColor = gradient.colors[0].cgColor
            gradientLayer.colors = [singleColor, singleColor]
        } else {
            gradientLayer.colors = gradient.colors.map({$0.cgColor})
        }
        
        gradientLayer.startPoint = gradient.direction.startPoint()
        gradientLayer.endPoint = gradient.direction.endPoint()
        gradientLayer.cornerRadius = 20
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientCornerRadiusAndShadow() {
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func getUIImageOfBtnString(name: String) -> UIImage {
        return UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium))!.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    @IBAction private func deleteBtnPressed(_ sender: UIButton) {
        self.deleteBtnPressed?()
    }
    
    @IBAction private func editBtnPressed(_ sender: UIButton) {
        self.editBtnPressed?()
    }
    
    @IBAction private func exportBtnPressed(_ sender: UIButton) {
        self.exportBtnPressed?()
    }
    
    @IBAction private func clearBtnPressed(_ sender: UIButton) {
        self.clearBtnPressed?()
    }
}

extension UIButton {
    func setCircleBackground(width: CGFloat){
        backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.6)
        
        layer.cornerRadius = 0.5 * (frame.size.width - 20)
    }
}

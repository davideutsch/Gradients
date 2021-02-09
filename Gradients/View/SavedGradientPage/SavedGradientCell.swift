//
//  SavedGradientCell.swift
//  Gradients
//
//  Created by David Deutsch on 06.12.20.
//

import UIKit

class SavedGradientCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    var deleteBtnPressed: (()->())?
    var editBtnPressed: (()->())?
    var exportBtnPressed: (()->())?
    
    var gradientLayer: CAGradientLayer?
    
    static let identifier = "SavedGradientCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with gradient: Gradient, active: Bool) {
        
        setGradientBackground(gradient)
        setGradientCornerRadiusAndShadow()
        setBtnStyle()
        
        rootStackView.isHidden = !active
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier,  bundle: nil)
    }
    
    @IBAction func clearBtnPressed(_ sender: UIButton) {
        rootStackView.isHidden = true
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        self.deleteBtnPressed?()
    }
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        self.editBtnPressed?()
    }
    
    @IBAction func exportBtnPressed(_ sender: UIButton) {
        self.exportBtnPressed?()
    }
    
    
    func setGradientBackground(_ gradient: Gradient) {
        backgroundView = UIView()
        backgroundView?.addGradientLayer(gradient: gradient)
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
    
    func getUIImageOfBtnString(name: String) -> UIImage {
        return UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium))!.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}

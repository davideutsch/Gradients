//
//  GradientCVCell.swift
//  Gradients
//
//  Created by David Deutsch on 05.12.20.
//

import UIKit

class GGradientCell: UICollectionViewCell {
    
    @IBOutlet weak var archiveBtn: UIButton!
    @IBOutlet weak var archiveBtnView: UIView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var archiveBtnPressed: (()->())?
    
    static let identifier = "GGradientCell"
    
    var active = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likesLabel.isHidden = true
    }
    
    public func configure(with gradient: Gradient, saved: Bool, active: Bool) {
        likesLabel.text = "Likes: \(gradient.likes)"
        
        setGradientBackground(gradient)
        setGradientCornerRadiusAndShadow()
        setBtnStyle()
        			 
        if saved {
            //show checked icon
            archiveBtn.setImage(getUIImageOfBtnString(name: "checkmark", color: .systemGreen), for: .normal)
            archiveBtnView.isHidden = false
            likesLabel.isHidden = true
            archiveBtn.isUserInteractionEnabled = false
        } else {
            //show saveable icon
            archiveBtn.setImage(getUIImageOfBtnString(name: "tray.and.arrow.down.fill"), for: .normal)
            archiveBtnView.isHidden = !active
            likesLabel.isHidden = false
            archiveBtn.isUserInteractionEnabled = true
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier,  bundle: nil)
    }

    @IBAction func archiveBtnPressed(_ sender: UIButton) {
        self.archiveBtnPressed?()
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
        
        archiveBtn.setCircleBackground(width: buttonWidth)
        archiveBtn.setTitle("", for: .normal)
    }
    
    func getUIImageOfBtnString(name: String, color : UIColor = .white) -> UIImage {
        return UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium))!.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}

extension UIView{
    func addGradientLayer(gradient: Gradient) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        if gradient.colors.count == 1 {
            let singleColor = UIColor(hexString: gradient.colors[0])!.cgColor
            gradientLayer.colors = [singleColor, singleColor]
        } else {
            gradientLayer.colors = gradient.colors.map({ UIColor(hexString: $0)!.cgColor})
        }
        
        gradientLayer.startPoint = gradient.direction.startPoint()
        gradientLayer.endPoint = gradient.direction.endPoint()
        gradientLayer.cornerRadius = 20
        layer.addSublayer(gradientLayer)
    }
}

extension UIButton {
    func setCircleBackground(width: CGFloat){
        backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.6)
        
        let radius = 0.5 * (frame.size.width - 20)
        layer.cornerRadius = radius
    }
}

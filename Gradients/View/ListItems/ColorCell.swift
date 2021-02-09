//
//  ColorCell.swift
//  Gradients
//
//  Created by David Deutsch on 11.11.20.
//

import UIKit
import SwipeCellKit

class ColorCell: SwipeTableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tapToEditColorLabel: UILabel!
    
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var tapToEditView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let numLabel = numberLabel, let editLabel = tapToEditColorLabel, let edtView = tapToEditView {
            numLabel.font = UIFont(name: "Montserrat-Regular", size: 25)
            numLabel.setShadow()
            editLabel.font = UIFont(name: "ConcertOne-Regular", size: 25)
            editLabel.setShadow()
            
            edtView.layer.borderWidth = 3
            if let borderColor = UIColor(named: "BorderColor") {
                edtView.layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = self.tapToEditView, let numberView = self.numberView {
//             tapToEditView.roundCorners(corners: [.topRight,.bottomRight], radius: 8)
            numberView.roundCorners(corners: [.topLeft,.bottomLeft], radius: 8)
         }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                if let view = tapToEditView, let borderColor = UIColor(named: "BorderColor") {
                    view.layer.borderColor = borderColor.cgColor
                }
                
            }
        }
    }
}

extension UILabel {
    func setShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.masksToBounds = false
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

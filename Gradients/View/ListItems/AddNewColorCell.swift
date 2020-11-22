//
//  AddNewColorCell.swift
//  Gradients
//
//  Created by David Deutsch on 12.11.20.
//

import UIKit

class AddNewColorCell: UITableViewCell {

    @IBOutlet weak var addColorLabel: UILabel!
    @IBOutlet weak var addColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let label = addColorLabel, let view = addColorView {
            label.font = UIFont(name: "Montserrat-Bold", size: 20)
            
            view.layer.borderWidth = 3
            if let borderColor = UIColor(named: "BorderColor") {
                view.layer.borderColor = borderColor.cgColor
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let view = self.addColorView{
             view.roundCorners(corners: [.topRight,.bottomRight,.topLeft,.bottomLeft], radius: 8)
         }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                // ColorUtils.loadCGColorFromAsset returns cgcolor for color name
                if let view = addColorView, let borderColor = UIColor(named: "BorderColor") {
                    view.layer.borderColor = borderColor.cgColor
                }
                
            }
        }
    }
}

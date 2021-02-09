//
//  GradientCVHeader.swift
//  Gradients
//
//  Created by David Deutsch on 05.12.20.
//

import UIKit

class GradientCVHeader: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "GradientCVHeader"
    
    override func awakeFromNib() { 
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 35)
    }
    
    func configure(text: String){
        titleLabel.text = text
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier,  bundle: nil)
    }
}

//
//  GradientsCollectionViewHeader.swift
//  Gradients
//
//  Created by David Deutsch on 25.11.20.
//

import UIKit

class GradientsCollectionViewHeader: UICollectionViewCell {
    
    let pointsLabel: UILabel = {
         let n = UILabel()
             n.textColor = UIColor.darkGray
             n.textAlignment = .center
             n.text = "Testing 123"
             n.font = UIFont(name: "Montserrat", size: 30)
         return n
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         addSubview(pointsLabel)

//         pointsLabel.translatesAutoresizingMaskIntoConstraints = false
//         pointsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 32.5).isActive = true
//         pointsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.5).isActive = true
//         pointsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//         pointsLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
     
//        self.isUserInteractionEnabled = true
    }
}

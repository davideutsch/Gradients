//
//  SavedGradient.swift
//  Gradients
//
//  Created by David Deutsch on 08.12.20.
//

import RealmSwift

class SavedGradient: Object {
    @objc dynamic var gradientID = UUID().uuidString
    @objc dynamic var direction : String = ""
    dynamic var colors = List<String>()
    
    convenience init(gradient: Gradient) {
        self.init()
        
        self.direction = gradient.direction.rawValue
        
        let colors = List<String>()
        gradient.colors.forEach {colors.append($0)}
        self.colors = colors
        
        if gradient.id != "" {
            self.gradientID = gradient.id
        }
    }
    
    override class func primaryKey() -> String? {
        return "gradientID"
    }
}

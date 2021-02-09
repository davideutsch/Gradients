//
//  Gradient.swift
//  Gradients
//
//  Created by David Deutsch on 20.11.20.
//

import UIKit
import RealmSwift
import Firebase

class Gradient {
    
    var id : String = UUID().uuidString
    var direction : Direction
    var colors = List<String>()
    var likes: Int = 0
    
    init(direction: Direction, colors: List<String>, id: String? = "") {
        self.direction = direction
        
        self.colors.removeAll()
        colors.forEach { (color) in
            self.colors.append(color)
        }
        
        self.handleId(id)
    }
    
    init(direction: Direction, colors: [String], id: String? = "") {
        self.direction = direction
        
        self.colors.removeAll()
        colors.forEach { (color) in
            self.colors.append(color)
        }
        
        self.handleId(id)
    }
    
    init(direction: String, colors: [String], id: String? = "") {
        switch direction {
            case Direction.TOPTOBOTTOM.rawValue:
                self.direction = Direction.TOPTOBOTTOM
                
            case Direction.LEFTTORIGHT.rawValue:
                self.direction = Direction.LEFTTORIGHT
                
            case Direction.TOPLEFTTOBOTTOMRIGHT.rawValue:
                self.direction = Direction.TOPLEFTTOBOTTOMRIGHT
                
            case Direction.BOTTOMLEFTTOTOPRIGHT.rawValue:
                self.direction = Direction.BOTTOMLEFTTOTOPRIGHT
                
            default:
                self.direction = Direction.TOPTOBOTTOM
        }
        
        self.colors.removeAll()
        colors.forEach { (color) in
            self.colors.append(color)
        }
         
        self.handleId(id)
        
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        switch snapshot.get("direction") as! String {
            case Direction.TOPTOBOTTOM.rawValue:
                self.direction = Direction.TOPTOBOTTOM
                
            case Direction.LEFTTORIGHT.rawValue:
                self.direction = Direction.LEFTTORIGHT
                
            case Direction.TOPLEFTTOBOTTOMRIGHT.rawValue:
                self.direction = Direction.TOPLEFTTOBOTTOMRIGHT
                
            case Direction.BOTTOMLEFTTOTOPRIGHT.rawValue:
                self.direction = Direction.BOTTOMLEFTTOTOPRIGHT
                
            default:
                self.direction = Direction.TOPTOBOTTOM
        }
        
        self.colors.removeAll()
        let colors = snapshot.get("colors") as! [String]
        for color in colors {
            self.colors.append(color)
        }
        
        self.id = snapshot.get("id") as! String
        self.likes = snapshot.get("likes") as! Int
    }
    
    private func handleId(_ id: String?) {
        if let id = id {
            if id != "" {
                self.id = id
            }
        }
    }
}

enum Direction: String {
    case TOPTOBOTTOM = "TopToBottom"
    case LEFTTORIGHT = "LeftToRight"
    case TOPLEFTTOBOTTOMRIGHT = "TopLeftToBottomRight"
    case BOTTOMLEFTTOTOPRIGHT = "BottomLeftToTopRight"
    
    func startPoint() -> CGPoint {
        switch self {
        case .TOPLEFTTOBOTTOMRIGHT:
            return CGPoint(x: 0.0, y: 0.0)
        case .BOTTOMLEFTTOTOPRIGHT:
            return CGPoint(x: 0.0, y: 1.0)
        case .LEFTTORIGHT:
            return CGPoint(x: 0.0, y: 0.5)
        case .TOPTOBOTTOM:
            return CGPoint(x: 0.5, y: 0.0)
        }
    }
    
    func endPoint() -> CGPoint {
        switch self {
        case .TOPLEFTTOBOTTOMRIGHT:
            return CGPoint(x: 1.0, y: 1.0)
        case .BOTTOMLEFTTOTOPRIGHT:
            return CGPoint(x: 1.0, y: 0.0)
        case .LEFTTORIGHT:
            return CGPoint(x: 1.0, y: 0.5)
        case .TOPTOBOTTOM:
            return CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    func arrowImage() -> UIImage {
        let iconSystemName: String
        switch self {
            case .TOPLEFTTOBOTTOMRIGHT:
                iconSystemName = "arrow.down.right"
            case .BOTTOMLEFTTOTOPRIGHT:
                iconSystemName = "arrow.up.right"
            case .LEFTTORIGHT:
                iconSystemName = "arrow.right"
            case .TOPTOBOTTOM:
                iconSystemName = "arrow.down"
        }
        
        return UIImage(systemName: iconSystemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .medium))!.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}

extension Direction {
    init(_ direction: Direction) {
        switch direction.rawValue {
            case Direction.TOPTOBOTTOM.rawValue:
                self = Direction.TOPTOBOTTOM
                
            case Direction.LEFTTORIGHT.rawValue:
                self = Direction.LEFTTORIGHT
                
            case Direction.TOPLEFTTOBOTTOMRIGHT.rawValue:
                self = Direction.TOPLEFTTOBOTTOMRIGHT
                
            case Direction.BOTTOMLEFTTOTOPRIGHT.rawValue:
                self = Direction.BOTTOMLEFTTOTOPRIGHT
                
            default:
                self = Direction.TOPTOBOTTOM
        }
    }
}

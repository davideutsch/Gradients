//
//  Gradient.swift
//  Gradients
//
//  Created by David Deutsch on 20.11.20.
//

import UIKit

struct Gradient {
    var direction: Direction
    var colors: [UIColor]
}

enum Direction {
    case TOPTOBOTTOM
    case LEFTTORIGHT
    case TOPLEFTTOBOTTOMRIGHT
    case BOTTOMLEFTTOTOPRIGHT
    
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

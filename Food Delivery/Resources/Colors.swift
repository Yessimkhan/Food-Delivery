//
//  Colors.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 22.06.2023.
//

import UIKit

extension UIColor {
    convenience init (hex: String) {
        var hexSanitized = hex.trimmingCharacters (in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences (of: "#", with:"")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        Scanner (string: hexSanitized).scanHexInt64(&rgb)
        
        if length == 6 {
            r = CGFloat ( (rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat ( (rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat (rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat ( (rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat ( (rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat ( (rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat (rgb & 0x000000FF) / 255.0
        }
        
        self.init (red: r, green: g, blue: b, alpha: a)
    }
}


struct Colors {
    static let backgroundColor = UIColor(named: "BackgroundColor")
    static let tintColor = UIColor(hex: "FD3A69")
    static let textColor = UIColor(named: "TextColor")
    static let whiteBlack = UIColor(named: "wb")
    static let blackWhite = UIColor(named: "bw")
//    static let blue = UIColor(named: "Blue")
//    static let tintColor = UIColor(named: "tintColor")
}

//
//  Fonts.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 22.06.2023.
//

import UIKit

extension UIFont {
  func withWeight(_ weight: UIFont.Weight) -> UIFont {
    let newDescriptor = fontDescriptor.addingAttributes([.traits: [
      UIFontDescriptor.TraitKey.weight: weight]
    ])
    return UIFont(descriptor: newDescriptor, size: pointSize)
  }
}

struct Fonts {
    static let SFUIDisplay = UIFont(name: "SFUIDisplay-Medium", size: 34)
}

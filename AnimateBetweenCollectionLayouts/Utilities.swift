//
//  Utilities.swift
//  AnimateBetweenCollectionLayouts
//
//  Created by Zheng on 8/14/21.
//

import UIKit

class Cell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var label: UILabel!
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

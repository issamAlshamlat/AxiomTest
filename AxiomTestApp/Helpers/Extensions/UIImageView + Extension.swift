//
//  UIImageView + Extension.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.sd_setImage(with: url, placeholderImage: placeholder)
    }
    
}

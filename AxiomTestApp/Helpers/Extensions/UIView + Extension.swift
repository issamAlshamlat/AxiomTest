//
//  UIView + Extension.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import UIKit

extension UIView {
    func addRoundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        // Create a subview to hold the background color
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = self.backgroundColor
        
        // Add the mask layer to the subview's layer
        backgroundView.layer.mask = maskLayer
        
        // Add the background view as a subview
        addSubview(backgroundView)
        
        // Clear the background color of the main view
        self.backgroundColor = .clear
    }
}

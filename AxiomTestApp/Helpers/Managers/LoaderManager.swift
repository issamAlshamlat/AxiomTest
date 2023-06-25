//
//  LoaderHelper.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation
import UIKit

class LoaderManager {
    private var loaderView: UIView?
    
    static let shared = LoaderManager()
    
    private init() {}
    
    func showLoader() {
        guard loaderView == nil else { return }
        
        loaderView = UIView(frame: UIScreen.main.bounds)
        loaderView!.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(loaderView!)

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loaderView!.center
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        loaderView!.addSubview(activityIndicator)
    }
    
    func hideLoader() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
}

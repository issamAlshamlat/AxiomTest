//
//  ConnectivityManager.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import Reachability

protocol ConnectivityManagerDelegate: AnyObject {
    func internetConnectionChanged(isConnected: Bool)
}

class ConnectivityManager {

    static let shared = ConnectivityManager()
    
    private let reachability: Reachability
    weak var delegate: ConnectivityManagerDelegate?

    private init() {
        reachability = try! Reachability()
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: nil)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Failed to start reachability notifier: \(error)")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
    
    @objc private func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        
        if reachability.connection != .unavailable {
            // Internet connection is available
            DispatchQueue.main.async {
                self.delegate?.internetConnectionChanged(isConnected: true)
                
                if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
                   let presentedViewController = rootViewController.presentedViewController as? UIAlertController {
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            // Internet connection is lost
            self.delegate?.internetConnectionChanged(isConnected: false)
            let toastView = ToastView(message: .Toast.noInternetConnection)
            toastView.show()
        }
    }
}

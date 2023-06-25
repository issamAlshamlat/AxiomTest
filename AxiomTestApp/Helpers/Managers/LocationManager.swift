//
//  LocationManager.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D?, Error?) -> Void)?
    private var locationUpdateReceived = false
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        self.completion = completion
        
        // Check if location services are enabled
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if CLLocationManager.locationServicesEnabled() && (authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse) {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            let error = NSError(domain: "LocationManagerErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services authorization denied."])
            completion(nil, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()

        guard let location = locations.last, !locationUpdateReceived else {
            let error = NSError(domain: "LocationManagerErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get location."])
            completion?(nil, error)
            return
        }

        locationUpdateReceived = true
        let coordinate = location.coordinate
        completion?(coordinate, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        
        completion?(nil, error)
    }
    
    func resetLocationUpdateFlag() {
        locationUpdateReceived = false
    }
}

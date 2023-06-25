//
//  NetworkManager.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation
import CoreLocation

class NetworkManager {
    static let shared = NetworkManager()
    private let keychainManager = KeychainManager.shared
    
    private init() {}
    
    func fetchWeatherData(location: CLLocationCoordinate2D, completion: @escaping (WeatherResponseModel?, Error?) -> Void){
        
        guard let apiKey = keychainManager.getStringForKey(key: .KeychainKeys.weatherAPIKey), let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)") else {return}
 
        NetworkHelper.shared.getRequest(url: url, parameters: [:]) { (result: Result<WeatherResponseModel, Error>) in
            switch result {
            case .success(let response):
                // Handle successful response
                completion(response, nil)
            case .failure(let error):
                // Handle error
                print(error)
                completion(nil, error)
            }
        }
    }
}

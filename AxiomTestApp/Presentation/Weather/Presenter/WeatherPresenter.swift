//
//  WeatherPresenter.swift
//  snapkitTutorial
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation
import Swinject
import CoreLocation

protocol WeatherViewDelegate: AnyObject {
    func showWeatherData(weather: WeatherResponseModel)
    func showError(error: String)
}

protocol WeatherPresenterProtocol: AnyObject {
    func weatherFetched(weather: WeatherResponseModel)
    func weatherFetchFailed(withError error: String)
}

class WeatherPresenter {

    private let networkManager: NetworkManager
    private let coreDataManager: CoreDataManager
    private let connectivityManager: ConnectivityManager
    private var locationManager: LocationManager?
    
    weak private var delegate: WeatherViewDelegate?
    
    init(networkManager: NetworkManager, coreDataManager: CoreDataManager, connectivityManager: ConnectivityManager, locationManager: LocationManager) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.connectivityManager = connectivityManager
        self.locationManager = locationManager
    }
    
    func setViewDelegate(delegate: WeatherViewDelegate) {
        self.delegate = delegate
        self.connectivityManager.delegate = self
       
    }
    
    func fetchWeatherData(location: CLLocationCoordinate2D) {
        
        networkManager.fetchWeatherData(location: location) { [weak self] response, error in
            self?.locationManager?.resetLocationUpdateFlag()
            if let error = error {
                self?.weatherFetchFailed(withError: error.localizedDescription)
            }else {
                if let response = response {
                    self?.weatherFetched(weather: response)
                }else {
                    print("error")
                }
            }
        }
    }
    
    func getUserLocationAndFetchData() {
        
        locationManager?.getCurrentLocation {[weak self] location, error in
            if let error = error {
                self?.weatherFetchFailed(withError: .Toast.location_permission_error)
            }else {
                if let location = location {
                    self?.fetchWeatherData(location: location)
                }
            }
        }
    }
    
    func saveWeatherDataToDB(weather: WeatherResponseModel) {
        coreDataManager.saveWeatherData(weather)
    }

}

extension WeatherPresenter: ConnectivityManagerDelegate {
    func internetConnectionChanged(isConnected: Bool) {
        if !isConnected {
//            let weatherData = coreDataManager.fetchWeatherData()
//
//            let watherModel = WeatherResponseModel(coord: [], weather: [], base: nil, main: nil, visibility: <#T##Int?#>, wind: <#T##Wind?#>, clouds: <#T##Clouds?#>, dt: <#T##Int?#>, sys: <#T##System?#>, timezone: <#T##Int?#>, id: weatherData?.id, name: <#T##String?#>, cod: <#T##Int?#>)
            
            
//            self.weatherFetched(weather: <#T##WeatherResponseModel#>)
        }
    }
}

extension WeatherPresenter: WeatherPresenterProtocol {
    
    func weatherFetched(weather: WeatherResponseModel) {
        delegate?.showWeatherData(weather: weather)
    }

    func weatherFetchFailed(withError error: String) {
        delegate?.showError(error: error)
    }
    
}

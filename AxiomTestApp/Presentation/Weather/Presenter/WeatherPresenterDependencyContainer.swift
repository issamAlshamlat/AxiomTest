//
//  WeatherPresenterDependencyContainer.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import Swinject

class WeatherPresenterDependencyContainer {
    static let shared = WeatherPresenterDependencyContainer()
    
    private let container = Container()
    
    private init() {
        // Register dependencies
        container.register(NetworkManager.self) { _ in NetworkManager.shared }
        container.register(CoreDataManager.self) { _ in CoreDataManager.shared }
        container.register(ConnectivityManager.self) { _ in ConnectivityManager.shared }
        container.register(LocationManager.self) { _ in LocationManager.shared }
        container.register(WeatherPresenter.self) { resolver in
            let networkManager = resolver.resolve(NetworkManager.self)!
            let coreDataManager = resolver.resolve(CoreDataManager.self)!
            let connectivityManager = resolver.resolve(ConnectivityManager.self)!
            let locationmanager = resolver.resolve(LocationManager.self)!
            return WeatherPresenter(networkManager: networkManager, coreDataManager: coreDataManager, connectivityManager: connectivityManager, locationManager: locationmanager)
        }
    }
    
    func resolveWeatherPresenter() -> WeatherPresenter {
        return container.resolve(WeatherPresenter.self)!
    }
}

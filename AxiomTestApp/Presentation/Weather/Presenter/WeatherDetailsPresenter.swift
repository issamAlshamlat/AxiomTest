//
//  WeatherDetailsPresenter.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation

enum DegreeUnit: String {
    case fahrenheit = "F"
    case celsius = "C"
}

class WeatherDetailsPresenter {
    private let weather: WeatherResponseModel!
//    weak private var delegate: WeatherDetailsViewDelegate?
    
    init(weather: WeatherResponseModel) {
        self.weather = weather
    }
    
//    func setViewDelegate(delegate: WeatherDetailsViewDelegate) {
//        self.delegate = delegate
//    }
    
    func createCollectionViewDataSource() -> [WeatherDataModel] {
        var items: [WeatherDataModel] = []
        
        guard let weather = weather else {return []}
        
        if let humidity = weather.main?.humidity {
            let humidityDataModel = WeatherDataModel(title: .humidity_string, value: "\(humidity)", icon: .humidity_image, timeZone: nil)
            items.append(humidityDataModel)
        }
        
        if let pressure = weather.main?.pressure {
            let pressureDataModel = WeatherDataModel(title: .pressure_string, value: "\(pressure)", icon: .pressure_image, timeZone: nil)
            items.append(pressureDataModel)
        }

        if let speed = weather.wind?.speed {
            let windSpeedDataModel = WeatherDataModel(title: .wind_speed_string, value: "\(speed)", icon: .wind_speed_image, timeZone: nil)
            items.append(windSpeedDataModel)
        }

        if let sunrise = weather.sys?.sunrise {
            let sunriseDatamodel = WeatherDataModel(title: .sunrise_string, value: "\(sunrise)", icon: .sunrise_image, timeZone: weather.timezone)
            items.append(sunriseDatamodel)
        }
        
        if let sunset = weather.sys?.sunset {
            let sunsetDatamodel = WeatherDataModel(title: .sunset_string, value: "\(sunset)", icon: .sunset_image, timeZone: weather.timezone)
            items.append(sunsetDatamodel)
        }

        return items
//        delegate?.reloadData(with: items)
    }
    
    func weatherResponseModel() -> WeatherResponseModel {
        return weather
    }
    
    func degreeInCurrentUnit(unit: String, value: Double) -> Double {
        switch DegreeUnit(rawValue: unit) {
        case .fahrenheit:
            return kelvinToFahrenheit(kelvin: value).rounded(toDecimalPlaces: 2)
        case .celsius:
            return kelvinToCelsius(kelvin: value).rounded(toDecimalPlaces: 2)
        default:
            return value
        }
    }
    
    func kelvinToCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }

    func kelvinToFahrenheit(kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9/5 + 32
    }
}

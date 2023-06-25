//
//  WeatherResponseModel.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation

enum WeatherStatus: String {
    case rainy = "Rainy"
    case cloudy = "Cloudy"
    case sunny = "Sunny"
    case clear = "Clear"
    
    static func getDefault() -> WeatherStatus {
        return .clear
    }
    
    var imageName: String {
        return self.rawValue
    }
}

struct WeatherResponseModel: Decodable {
    let coord: Coordinates
    let weather: [Weather]
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: System?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}

struct Coordinates: Decodable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Decodable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
}

struct Clouds: Decodable {
    let all: Int?
}

struct System: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

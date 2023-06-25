//
//  AppStrings.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation

extension String {
    // MARK: - App String
    
    static let empty = ""
    static let degree_sign_string = "°"
    static let weather_string = "Weather"
    static let enter_lat_lng_textfield_placeholder_string = "Enter latitude, longitude"
    static let search_string = "Search"
    static let height_degree_string = "H:"
    static let low_degree_string = "L:"
    static let feels_like_string = "Feels Like"
    static let details_string = "Details"
    static let humidity_string = "Humidity"
    static let pressure_string = "Pressure"
    static let wind_speed_string = "Wind Speed"
    static let sunrise_string = "Sunrise"
    static let sunset_string = "Sunset"
    
    // MARK: - Image String
    
    static let emptyImage = ""
    static let sky_image_name = "sky"
    static let sky_with_clouds_image = "sky_with_clouds"
    static let humidity_image = "humidity"
    static let pressure_image = "pressure"
    static let wind_speed_image = "wind_speed"
    static let sunrise_image = "sunrise"
    static let sunset_image = "sunset"
    static let location_image = "location"
    
    // MARK: - Toast
    struct Toast {
        static let noInternetConnection = "No Internet Connection"
        static let connectionRestored = "Connection Restored"
        static let location_permission_error = "Weather required location in order to fetch data!"
    }
    
    struct KeychainKeys {
        static let weatherAPIKey = "WeatherAPIKey"
    }
    
}

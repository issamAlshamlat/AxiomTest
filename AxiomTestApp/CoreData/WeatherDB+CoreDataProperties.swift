//
//  WeatherDB+CoreDataProperties.swift
//  
//
//  Created by Mhd Baher on 25/06/2023.
//
//

import Foundation
import CoreData


extension WeatherDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDB> {
        return NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
    }

    @NSManaged public var country: String?
    @NSManaged public var dt: Int64
    @NSManaged public var feels_like: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var pressure: Double
    @NSManaged public var speed: Double
    @NSManaged public var temp: Double
    @NSManaged public var temp_max: Double
    @NSManaged public var temp_min: Double
    @NSManaged public var timeZone: Int64

}

//
//  CoreDataManager.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = AppDelegate.sharedAppDelegate.persistentContainer
    }
    
    func fetchWeatherData() -> WeatherDB? {
        let fetchRequest: NSFetchRequest<WeatherDB> = WeatherDB.fetchRequest()
        
        do {
            let weatherDBArray = try persistentContainer.viewContext.fetch(fetchRequest)
            return weatherDBArray.first
        } catch {
            print("Failed to fetch weather data: \(error)")
            return nil
        }
    }

    func saveWeatherData(_ weatherData: WeatherResponseModel) {
        let savedData = WeatherDB(context: persistentContainer.viewContext)
//        savedData.id = Int64(weatherData.id ?? 0)
//        savedData.country = weatherData.sys?.country
//        savedData.timeZone = Int64(weatherData.timezone ?? 0)
//        savedData.dt = Int64(weatherData.dt ?? 0)
//        savedData.feels_like = weatherData.main?.feels_like ?? 0
//        savedData.humidity = Int64(weatherData.main?.humidity ?? 0)
//        savedData.name = weatherData.name
//        savedData.pressure = Double(weatherData.main?.pressure ?? 0)
//        savedData.speed = weatherData.wind?.speed ?? 0
//        savedData.temp = weatherData.main?.temp ?? 0
//        savedData.temp_max = weatherData.main?.temp_max ?? 0
//        savedData.temp_min = weatherData.main?.temp_min ?? 0
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save weather data: \(error)")
        }
    }
}

extension CoreDataManager {
    private func rollBack() {
        DispatchQueue.main.async {
            self.persistentContainer.viewContext.rollback()
        }
    }

    func saveData() throws {
        try self.persistentContainer.viewContext.save()
    }

    func removeAllEntities<T: NSManagedObject>(_ entity: T.Type) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            print("Failed to remove entities: \(error)")
        }
    }
}

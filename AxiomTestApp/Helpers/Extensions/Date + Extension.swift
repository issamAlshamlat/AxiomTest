//
//  Date + Extension.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM"
        return dateFormatter.string(from: self)
    }
    
    func currentTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
    
    func timeStringFromTimeIntervalString(_ timeIntervalString: String, timeZone : Int) -> String? {
        if let timeInterval = TimeInterval(timeIntervalString) {
            let date = Date(timeIntervalSince1970: timeInterval)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            timeFormatter.timeZone = TimeZone(secondsFromGMT: Int(timeZone))
            let timeString = timeFormatter.string(from: date)
            
            return timeString
        }
        
        return nil
    }

}

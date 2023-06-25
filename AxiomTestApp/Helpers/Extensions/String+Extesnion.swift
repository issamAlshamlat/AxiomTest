//
//  String+Extesnions.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation

extension String {
    func extractCoordinates() -> (latitude: Double?, longitude: Double?) {
        let pattern = #"([-+]?\d{1,3}\.\d+),\s*([-+]?\d{1,3}\.\d+)"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
        
        if let match = matches.first, match.numberOfRanges == 3 {
            if let latitudeRange = Range(match.range(at: 1), in: self),
               let longitudeRange = Range(match.range(at: 2), in: self) {
                let latitudeString = self[latitudeRange]
                let longitudeString = self[longitudeRange]
                
                if let latitude = Double(latitudeString),
                   let longitude = Double(longitudeString) {
                    return (latitude, longitude)
                }
            }
        }
        
        return (nil, nil)
    }
}

//
//  Double+Extension.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation

extension Double {
    func rounded(toDecimalPlaces decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return (self * divisor).rounded() / divisor
    }
}

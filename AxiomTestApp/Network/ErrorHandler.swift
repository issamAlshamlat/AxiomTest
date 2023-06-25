//
//  ErrorHandler.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation

enum StatusCode: Int {
    case unauthorized = 401
    case unAuthenticated = 402
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    
    var localizedDescription: String {
        switch self {
        case .unauthorized:
            return NSLocalizedString("Your session has expired", comment: "")
        case .unAuthenticated:
            return NSLocalizedString("Unauthenticated", comment: "")
        case .forbidden:
            return NSLocalizedString("Invalid request", comment: "")
        case .notFound:
            return NSLocalizedString("URL not found", comment: "")
        case .internalServerError:
            return NSLocalizedString("Internal server error", comment: "")
        // Handle other status codes
        }
    }
}

class ErrorHandler {
    static func handleNetworkErrors<T>(result: Result<T, Error>, error: Error?, response: HTTPURLResponse?) -> String {
        guard let statusCode = response?.statusCode else {
            return "No response received"
        }
        
        if let status = StatusCode(rawValue: statusCode) {
            let errorMessage = status.localizedDescription
            return errorMessage
        } else {
            let errorMessage = NSLocalizedString("Some unexpected error happened", comment: "")
            return errorMessage
        }
    }
}

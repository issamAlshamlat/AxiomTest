//
//  UserDefaultsManager.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    // MARK: - Convenience Methods
    
    func setValue(_ value: Any?, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }
    
    func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

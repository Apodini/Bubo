//
//  CheckInitRoot.swift
//  Bubo
//
//  Created by Valentin Hartig on 06/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation


// MARK: ResourceManager
extension ResourceManager {
    
    /// Checks if the application has been initialised
    ///
    /// - returns: Retruns a boolean value that indicates if the application has been initalised
    public func checkInit() -> Bool {
        guard getRootConfigPath() != nil else {
            return false
        }
        return true // Initialised if root config file exists
    }
}

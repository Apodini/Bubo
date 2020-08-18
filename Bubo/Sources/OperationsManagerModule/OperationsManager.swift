//
//  OperationsManager.swift
//  Bubo
//
//  Created by Valentin Hartig on 19/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ResourceManagerModule


// MARK: OperationsManager
/// Main class of the operations manager
public class OperationsManager {
    
    /// Builds the resource manager which recovers the latest state of Bubo
    public var resourceManager: ResourceManager
    
    /// Provide a unified FileManager for all operations
    var fileManager: FileManager
    
    public init() {
        resourceManager = ResourceManager()
        fileManager = FileManager.default
    }
}

//
//  EncodeJSON.swift
//  Bubo
//
//  Created by Valentin Hartig on 17/06/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation


// MARK: ResouceManager
extension ResourceManager {
    
    /// Encodes root configuration data to JSON
    ///
    /// - parameter config: The root configuration data that should be encoded
    /// - returns: The encoded root configuration data if encoding was successful
    
    public func encodeDataToJSON(config: ProgramConfiguration) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode root configuration file")
            return nil
        }
    }
    
    
    /// Encodes project configuration data to JSON
    ///
    /// - parameter config: The project configuration data that should be encoded
    /// - returns: The encoded project configuration data if encoding was successful
    public func encodeDataToJSON(config: ProjectConfiguration) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode project configuration file")
            return nil
        }
    }
    
    
    /// Encodes service configuration data to JSON
    ///
    /// - parameter config: The service configuration data that should be encoded
    /// - returns: The encoded service configuration data if encoding was successful
    public func encodeDataToJSON(config: ServiceConfiguration) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode service configuration file")
            return nil
        }
    }
    
    
    /// Encodes graphSnapshot data to JSON
    ///
    /// - parameter config: The graphSnapshot data that should be encoded
    /// - returns: The encoded graphSnapshot data if encoding was successful
    public func encodeDataToJSON(config: GraphSnapshot) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode service configuration file")
            return nil
        }
    }
}

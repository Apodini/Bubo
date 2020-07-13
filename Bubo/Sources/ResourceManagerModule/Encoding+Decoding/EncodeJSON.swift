//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation


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
    /// - parameter config: The project configuration data that should be encoded
    /// - returns: The encoded project configuration data if encoding was successful
    
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

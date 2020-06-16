//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Encodes root configuration data to JSON
    ///
    /// - parameter config: The root configuration data that should be encoded
    /// - returns: The encoded root configuration data if encoding was successful
    
    func encodeDataToJSON(config: Buborc) -> Data? {
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
    
    func encodeDataToJSON(config: Anchorrc) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode project configuration file")
            return nil
        }
    }
}

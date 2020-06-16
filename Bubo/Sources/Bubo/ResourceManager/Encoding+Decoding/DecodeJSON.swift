//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Decodes a root configuration that is encoded in JSON
    ///
    /// - parameter url: The URL the JSON encoded root configuration is located at
    
    func decodeDatafromJSON(url: URL) -> Optional<Buborc> {
        let decoder = JSONDecoder()
        var config: Buborc?
        do {
            try config = decoder.decode(Buborc.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Decoder couldn't decode root configuration file at path \(url.path)")
            return nil
        }
        return config
    }
    
    
    /// Decodes a project configuration that is encoded in JSON
    ///
    /// - parameter url: The URL the JSON encoded project configuration is located at
    
    func decodeProjectConfigfromJSON(url: URL) -> Optional<Anchorrc> {
        let decoder = JSONDecoder()
        var config: Anchorrc?
        do {
            try config = decoder.decode(Anchorrc.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Decoder couldn't decode project configuration file at path \(url.path)")
            return nil
        }
        return config
    }
}

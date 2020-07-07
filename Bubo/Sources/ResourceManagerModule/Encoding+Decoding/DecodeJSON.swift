//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation
import BuboModelsModule
import OutputStylingModule

extension ResourceManager {
    
    /// Decodes a root configuration that is encoded in JSON
    ///
    /// - parameter url: The URL the JSON encoded root configuration is located at
    
    public func decodeDatafromJSON(url: URL) -> Optional<ProgramConfiguration> {
        let decoder = JSONDecoder()
        var config: ProgramConfiguration?
        do {
            try config = decoder.decode(ProgramConfiguration.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Decoder couldn't decode root configuration file at path \(url.path)")
            return nil
        }
        return config
    }
    
    
    /// Decodes a project configuration that is encoded in JSON
    ///
    /// - parameter url: The URL the JSON encoded project configuration is located at
    
    public func decodeProjectConfigfromJSON(url: URL) -> Optional<ProjectConfiguration> {
        let decoder = JSONDecoder()
        var config: ProjectConfiguration?
        do {
            try config = decoder.decode(ProjectConfiguration.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Decoder couldn't decode project configuration file at path \(url.path)")
            return nil
        }
        return config
    }
    
    
    /// Decodes a service configuration that is encoded in JSON
    ///
    /// - parameter url: The URL the JSON encoded project configuration is located at
    
    public func decodeServiceConfigfromJSON(url: URL) -> Optional<ServiceConfiguration> {
        let decoder = JSONDecoder()
        var config: ServiceConfiguration?
        do {
            try config = decoder.decode(ServiceConfiguration.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Decoder couldn't decode service configuration file at path \(url.path)")
            return nil
        }
        return config
    }
}

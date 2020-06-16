//
//  File.swift
//  
//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Decodes the root configuration and saves it to the globally available `rootConfig` variable
    
    func decodeRootConfig() -> Void {
        /// Fetch directory path for applications root directory
        guard let configURL = getRootConfigPath() else {
            abortMessage(msg: "Decoding of root configuration file")
            return
        }
        guard let decodedRootConfiguration = decodeDatafromJSON(url: configURL.absoluteURL) else {
            abortMessage(msg: "Decoding of root configuration file")
            return
        }
        rootConfig = decodedRootConfiguration
    }
}

//
//  File.swift
//  
//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    func encodeRootConfig(configFile: Buborc) -> Void {
        // outputMessage(msg: "Encoding bubo root configuration file")
        let fileManager: FileManager = FileManager()
        guard let configURL = getRootConfigPath() else {
            abortMessage(msg: "Encoding of root configuration")
            return
        }
        let encode = encodeDataToJSON(config: rootConfig)
        do {
            try fileManager.removeItem(at: configURL)
        } catch {
            errorMessage(msg: "Root configuration file can't be overwritten at path: \(configURL.path)")
            return
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if isCreated {
            rootConfig = configFile
            // successMessage(msg: "Root configuration file encoded")
            return
        } else {
            errorMessage(msg: "Root configuration file can't be overwritten at path: \(configURL.path)")
            return
        }
    }
}

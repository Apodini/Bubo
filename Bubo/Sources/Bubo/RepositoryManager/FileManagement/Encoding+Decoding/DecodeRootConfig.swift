//
//  File.swift
//  
//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension FileManagement {
    func decodeRootConfig() -> Void {
        // Create directory path for bubos root directory
        guard let configPath = getRootConfigPath() else {
            abortMessage(msg: "Decoding of root configuration file")
            return
        }
        guard let decoded = decodeDatafromJSON(url: configPath.absoluteURL) else {
            abortMessage(msg: "Decoding of root configuration file")
            return
        }
        rootConfig = decoded
    }
}

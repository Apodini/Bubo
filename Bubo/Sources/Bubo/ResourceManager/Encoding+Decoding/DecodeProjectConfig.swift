//
//  File.swift
//  
//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation


extension ResourceManager {
    func decodeProjectConfig(projectName: String?) -> (String, Anchorrc)? {
        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: projectName) else {
            abortMessage(msg: "Refresh services")
            return nil
        }
        let configURL = projectURL.appendingPathComponent("anchorrc").appendingPathExtension("json")
        let fileURL = URL(fileURLWithPath: configURL.path)
        guard let projectConfig = decodeProjectConfigfromJSON(url: fileURL) else {
            return nil
        }
        return (projectHandle, projectConfig)
    }
}

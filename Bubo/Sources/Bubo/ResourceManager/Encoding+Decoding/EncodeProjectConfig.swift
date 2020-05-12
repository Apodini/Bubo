//
//  File.swift
//  
//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    func encodeProjectConfig(pName: String, configData: Anchorrc) -> Void {
        let fileManager: FileManager = FileManager()
        
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't encode project configuration for \(pName) because no projects exists in root configuration")
            return
        }
        
        let projectNames = rootConfig.projects?.keys
        
        if !(projectNames?.contains(pName) ?? false) {
            errorMessage(msg: "Can't encode project configuration because \(pName) is not existing. Use Bubo new \(pName) to initialise the new project or use the --new option on th add command")
            return
        }
        guard let configURL = projects[pName]?.appendingPathComponent("anchorrc").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get projects configuration file path for \(pName). Does the project exist?")
            return
        }
        
        guard let encode = encodeDataToJSON(config: configData) else {
            abortMessage(msg: "Encoding of project configuration")
            return
        }
        
        let configFileURL = URL(fileURLWithPath: configURL.path)
        do {
            try fileManager.removeItem(at: configFileURL)
        } catch {
            errorMessage(msg: "Can't remove project configuration file for \(pName) at path \(configURL)")
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if isCreated {
            // successMessage(msg: "Project configuration file for \(projectName) overwritten at path: \(configURL)")
        } else {
            errorMessage(msg: "Project configuration file for \(pName) can't be overwritten at path: \(configURL)")
            return
        }
    }
}

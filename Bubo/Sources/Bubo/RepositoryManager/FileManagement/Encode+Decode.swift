//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation


extension FileManagment {
    
    // ----------------------- Encode and Decode functions
    func encodeDataToJSON(config: Buborc) -> Data {
        let encoder = JSONEncoder()
        var data: Data = Data.init()
        do {
            try data = encoder.encode(config)
        } catch {
            errorMessage(msg: "Couldn't encode root configuration file")
        }
        return data
    }
    
    func encodeDataToJSON(config: Anchorrc) -> Data {
        let encoder = JSONEncoder()
        var data: Data = Data.init()
        do {
            try data = encoder.encode(config)
        } catch {
            errorMessage(msg: "Couldn't encode root configuration file")
        }
        return data
    }
    
    func decodeDatafromJSON(path: URL) -> Optional<Buborc> {
        let decoder = JSONDecoder()
        var config: Buborc?
        do {
            try config = decoder.decode(Buborc.self, from: Data(contentsOf: path))
        } catch {
            errorMessage(msg: "Couldn't decode root configuration file at path  \(path)")
            config = nil
        }
        return config
    }
    
    func decodeProjectConfigfromJSON(url: URL) -> Optional<Anchorrc> {
        let decoder = JSONDecoder()
        var config: Anchorrc?
        do {
            try config = decoder.decode(Anchorrc.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Couldn't decode project configuration file at path \(url)")
            config = nil
        }
        return config
    }
    
    func encodeRootConfig(configFile: Buborc) -> Void {
        let fileManager: FileManager = FileManager()
        guard let configPath = getRootConfigPath() else {
            errorMessage(msg: "Can't get Bubo config path")
            return
        }
        let encode = encodeDataToJSON(config: rootConfig)
        do {
            try fileManager.removeItem(at: configPath)
        } catch {
            errorMessage(msg: "Can't remove root configuration file at path \(configPath)")
        }
        let isCreated = fileManager.createFile(atPath: configPath.path, contents: encode, attributes: nil)
        if isCreated {
            rootConfig = configFile
            successMessage(msg: "Root configuration file overwritten at path: \(configPath)")
        } else {
            errorMessage(msg: "Root configuration file can't be overwritten at path: \(configPath)")
            return
        }
    }
    
    func decodeRootConfig() -> Void {
        // Create directory path for bubos root directory
        guard let configPath = getRootConfigPath() else {
            errorMessage(msg: "Can't get root configuration file path")
            return
        }
        guard let decoded = decodeDatafromJSON(path: configPath.absoluteURL) else {
            errorMessage(msg: "Failed to decode root configuration file")
            return
        }
        rootConfig = decoded
    }
    
    func decodeProjectConfig(projectName: String) -> Optional<Anchorrc> {
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't get projects from runtime configuration.")
            return nil
        }
        
        let projectNames = rootConfig.projects?.keys
        
        if !(projectNames?.contains(projectName) ?? false) {
            errorMessage(msg: "Can't update services because \(projectName) is not existing. Use Bubo new \(projectName) to initialise the new project or use the --new option on th add command")
            return nil
        }
        guard let configURL = projects[projectName]?.appendingPathComponent("anchorrc").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get projects configuration file path")
            return nil
        }
        let fileURL = URL(fileURLWithPath: configURL.path)
        return decodeProjectConfigfromJSON(url: fileURL)
    }
    
    func encodeProjectConfig(projectName: String, configData: Anchorrc) -> Void {
        let fileManager: FileManager = FileManager()

        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't get projects from runtime configuration.")
            return
        }
        
        let projectNames = rootConfig.projects?.keys
        
        if !(projectNames?.contains(projectName) ?? false) {
            errorMessage(msg: "Can't encode project configuration because \(projectName) is not existing. Use Bubo new \(projectName) to initialise the new project or use the --new option on th add command")
            return
        }
        guard let configURL = projects[projectName]?.appendingPathComponent("anchorrc").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get projects configuration file path for \(projectName)")
            return
        }
        let encode = encodeDataToJSON(config: configData)
        let configFileURL = URL(fileURLWithPath: configURL.path)
        do {
            try fileManager.removeItem(at: configFileURL)
        } catch {
            errorMessage(msg: "Can't remove project configuration file for \(projectName) at path \(configURL)")
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if isCreated {
            successMessage(msg: "Project configuration file for \(projectName) overwritten at path: \(configURL)")
        } else {
            errorMessage(msg: "Project configuration file for \(projectName) can't be overwritten at path: \(configURL)")
            return
        }
    }
}

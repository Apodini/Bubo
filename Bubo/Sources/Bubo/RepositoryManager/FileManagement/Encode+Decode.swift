//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation


extension FileManagment {
    
    // ----------------------- Encode and Decode functions
    
    func encodeDataToJSON(config: Buborc) -> Optional<Data> {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode root configuration file")
            return nil
        }
    }
    
    func encodeDataToJSON(config: Anchorrc) -> Optional<Data> {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode project configuration file")
            return nil
        }
    }
    
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
    
    func decodeProjectConfig(projectName: String) -> Optional<Anchorrc> {
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't decode project configuration for \(projectName) because no projects exists in root configuration")
            return nil
        }
        
        let projectNames = rootConfig.projects?.keys
        
        if !(projectNames?.contains(projectName) ?? false) {
            errorMessage(msg: "Can't update services because \(projectName) is not existing. Use Bubo new \(projectName) to initialise the new project or use the --new option on th add command")
            return nil
        }
        guard let configURL = projects[projectName]?.appendingPathComponent("anchorrc").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get projects configuration file path. Does the project exist?")
            return nil
        }
        let fileURL = URL(fileURLWithPath: configURL.path)
        return decodeProjectConfigfromJSON(url: fileURL)
    }
    
    func encodeProjectConfig(projectName: String, configData: Anchorrc) -> Void {
        let fileManager: FileManager = FileManager()
        
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't encode project configuration for \(projectName) because no projects exists in root configuration")
            return
        }
        
        let projectNames = rootConfig.projects?.keys
        
        if !(projectNames?.contains(projectName) ?? false) {
            errorMessage(msg: "Can't encode project configuration because \(projectName) is not existing. Use Bubo new \(projectName) to initialise the new project or use the --new option on th add command")
            return
        }
        guard let configURL = projects[projectName]?.appendingPathComponent("anchorrc").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get projects configuration file path for \(projectName). Does the project exist?")
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
            errorMessage(msg: "Can't remove project configuration file for \(projectName) at path \(configURL)")
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if isCreated {
            // successMessage(msg: "Project configuration file for \(projectName) overwritten at path: \(configURL)")
        } else {
            errorMessage(msg: "Project configuration file for \(projectName) can't be overwritten at path: \(configURL)")
            return
        }
    }
}

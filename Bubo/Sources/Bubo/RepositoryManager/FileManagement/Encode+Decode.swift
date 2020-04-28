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
        var buborc: Buborc?
        do {
            try buborc = decoder.decode(Buborc.self, from: Data(contentsOf: path))
        } catch {
            errorMessage(msg: "Couldn't decode root configuration file at path  \(path)")
            buborc = nil
        }
        return buborc
    }
    
    func encodeRootConfig(configFile: Buborc) -> Void {
        let fileManager: FileManager = FileManager()
        guard let configPath = getBuboConfigPath() else {
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
        guard let configPath = getBuboConfigPath() else {
            errorMessage(msg: "Can't get root configuration file path")
            return
        }
        guard let decoded = decodeDatafromJSON(path: configPath.absoluteURL) else {
            errorMessage(msg: "Failed to decode root configuration file")
            return
        }
        rootConfig = decoded
    }
}

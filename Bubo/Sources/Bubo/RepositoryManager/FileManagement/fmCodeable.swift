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
            NSLog("ERROR: Couldn't encode buborc")
        }
        return data
    }
    
    func encodeDataToJSON(config: Anchorrc) -> Data {
        let encoder = JSONEncoder()
        var data: Data = Data.init()
        do {
            try data = encoder.encode(config)
        } catch {
            NSLog("ERROR: Couldn't encode buborc")
        }
        return data
    }
    
    func decodeDatafromJSON(path: URL) -> Optional<Buborc> {
        let decoder = JSONDecoder()
        var buborc: Buborc?
        do {
            try buborc = decoder.decode(Buborc.self, from: Data(contentsOf: path))
        } catch {
            NSLog("ERROR: Couldn't decode \(path)")
            buborc = nil
        }
        return buborc
    }
    
    func encodeRootConfig(configFile: Buborc) -> Void {
        let fileManager: FileManager = FileManager()
        guard let configPath = getBuboConfigPath() else {
            NSLog("ERROR: Can't get bubo config path")
            return
        }
        let encode = encodeDataToJSON(config: rootConfig)
        do {
            try fileManager.removeItem(at: configPath)
        } catch {
            NSLog("ERROR: Can't removee buborc at path \(configPath)")
        }
        let isCreated = fileManager.createFile(atPath: configPath.path, contents: encode, attributes: nil)
        if isCreated {
            rootConfig = configFile
            NSLog("buborc overwritten at path: \(configPath)")
        } else {
            NSLog("ERROR: buborc can't be overwritten at path: \(configPath)")
            return
        }
    }
    
    func decodeRootConfig() -> Void {
        // Create directory path for bubos root directory
        guard let configPath = getBuboConfigPath() else {
            NSLog("ERROR: Can't get bubo config path")
            return
        }
        guard let decoded = decodeDatafromJSON(path: configPath.absoluteURL) else {
            NSLog("ERROR: Failed to decode root configuration")
            return
        }
        rootConfig = decoded
    }
}

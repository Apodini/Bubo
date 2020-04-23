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
    
    func decodeRootConfig() -> Void {
        // Create directory path for bubos root directory
        guard let filePath = getBuboRepoDir() else {
            NSLog("ERROR: Can't get bubo root path")
            return
        }
        if self.fileManager.fileExists(atPath: filePath.path) {
            // Create path for root config file
            let configPath = URL(fileURLWithPath: filePath
            .appendingPathComponent("buborc")
                .appendingPathExtension("json").path)
            
            if self.fileManager.fileExists(atPath: configPath.path) {
                // Decode config file data
                guard let decoded = decodeDatafromJSON(path: configPath.absoluteURL) else {
                    NSLog("ERROR: Failed to decode root configuration")
                    return
                }
                rootConfig = decoded
            }
        }
    }
}

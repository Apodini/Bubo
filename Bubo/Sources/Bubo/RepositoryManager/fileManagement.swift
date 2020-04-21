//
//  File.swift
//  
//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

class FileManagment {
    // ----------------------- Declarations
    public var fileManager: FileManager
    
    // ----------------------- Initialisation
    
    init() {
        self.fileManager = FileManager.default
    }
    
    // ----------------------- Root repository initialisation functions
    
    // Checks if the root repository of the application has been initialised
    func checkInit() -> Bool {
        if let DocumentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let filePath = DocumentDirectory.appendingPathComponent("BuboProjects")
            
            if self.fileManager.fileExists(atPath: filePath.path) {
                let configPath = filePath
                    .appendingPathComponent("buborc")
                    .appendingPathExtension("json")
                if self.fileManager.fileExists(atPath: configPath.path) {
                    return true // Initialised if root config file exists
                } else {
                    return false // Not initialised if root config file is not existent
                }
            } else {
                return false // Not initialised if bubo root directory is not existing
            }
        }
        return false // Not initialised if documents directory is not existing
    }
    
    func initBubo() -> Bool {
        if let DocumentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Create directory path for bubos root directory
            let filePath =  DocumentDirectory.appendingPathComponent("BuboProjects")
            if !self.fileManager.fileExists(atPath: filePath.path) {
                do {
                    // Try to generate the root directory at path
                    try self.fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    if self.fileManager.fileExists(atPath: filePath.path) {
                        // Create path for root config file
                        let configPath = filePath
                            .appendingPathComponent("buborc")
                            .appendingPathExtension("json")
                        // Create config file Data
                        var configFile: Buborc = Buborc(
                            version: versionNumber,
                            projects: [],
                            rootRepoUrl: configPath,
                            initialisationDate: Date().description(with: .current)
                        )
                        
                        
                        if !self.fileManager.fileExists(atPath: configPath.path) {
                            // Encode config file data
                            let data: Data = encodeDataToJSON(config: configFile)
                            // Try to generate config file at above metioned path
                            let isCreated = fileManager
                                .createFile(atPath: configPath.path, contents: data, attributes: nil)
                            if isCreated {
                                rootConfig = configFile
                                NSLog("buborc created at path: \(configPath)")
                            } else {
                                NSLog("ERROR: buborc can't be created at path: \(configPath)")
                                return false
                            }
                        } else {
                            updateBuborc(config: configFile, path: configPath)
                        }
                    }
                } catch {
                    NSLog("Couldn't create document directory")
                    return false
                }
                NSLog("Document directory is \(filePath)")
                return true
            }
        }
        return false
    }
    
    func updateBuborc(config: Buborc, path: URL) {
        // Compare existing config file with new one and update existing
        NSLog("buborc at path \(path) updated")
    }
    
    func decodeRootConfig() -> Void {
        if let DocumentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Create directory path for bubos root directory
            let filePath =  DocumentDirectory.appendingPathComponent("BuboProjects")
            if self.fileManager.fileExists(atPath: filePath.path) {
                // Create path for root config file
                let configPath = filePath
                    .appendingPathComponent("buborc")
                    .appendingPathExtension("json")
                if self.fileManager.fileExists(atPath: configPath.path) {
                    // Encode config file data
                    let decoded = decodeDatafromJSON(path: configPath)
                    if decoded != nil {
                        rootConfig = decoded!
                        NSLog("Root configuration decoded: \(rootConfig)")
                    } else {
                        NSLog("ERROR: Failed to decode root configuration")
                    }
                }
            }
        }
    }
    
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
            NSLog("ERROR: Couldn't encode buborc")
            buborc = nil
        }
        return buborc
    }
    
    
    // ----------------------- New repository initialisation functions
    
    func initNewRepo(name: String) -> Bool {
        // Create the directory name
        var dirName = name
        dirName.append("Anchor")
        
        if let DocumentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Create the directory path
            let repoPath =  DocumentDirectory
                .appendingPathComponent("BuboProjects")
                .appendingPathComponent("\(name)")
            
            if !self.fileManager.fileExists(atPath: repoPath.path) {
                do {
                    // Generate the directory at the directory path
                    try self.fileManager.createDirectory(atPath: repoPath.path, withIntermediateDirectories: true, attributes: nil)
                    if self.fileManager.fileExists(atPath: repoPath.path) {
                        // Create the path for the config file of the new repo
                        let configPath = repoPath
                            .appendingPathComponent("anchorrc")
                            .appendingPathExtension("json")
                        // Create anchor config file
                        var configFile: Anchorrc = Anchorrc(
                            url: repoPath,
                            projectName: name,
                            creator: "NSFullUserName()",
                            creationTimestamp: Date().description(with: .current),
                            repositories: [],
                            lastUpdated: Date().description(with: .current)
                        )
                        if !self.fileManager.fileExists(atPath: configPath.path) {
                            // Try to generate config file and log progress
                            let data: Data = encodeDataToJSON(config: configFile)
                            let isCreated = self.fileManager
                                .createFile(atPath: configPath.path, contents: data, attributes: nil)
                            if isCreated {
                                NSLog("anchorrc created at path: \(configPath)")
                            } else {
                                NSLog("ERROR: anchorrc can't be created at path: \(configPath)")
                                return false
                            }
                        }
                    }
                } catch {
                    NSLog("Couldn't create document directory")
                    return false
                }
                NSLog("Document directory is \(repoPath)")
                return true
            }
        }
        return false
    }
}

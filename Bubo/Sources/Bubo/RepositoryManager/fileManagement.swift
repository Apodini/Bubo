//
//  File.swift
//  
//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

class FileManagment {
    
    public var fileManager: FileManager
    
    init() {
        self.fileManager = FileManager.default
    }
    
    func checkInit() -> Bool {
        if let tDocumentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = tDocumentDirectory.appendingPathComponent("BuboProjects")
            if self.fileManager.fileExists(atPath: filePath.path) {
                let configPath = filePath
                    .appendingPathComponent("buborc")
                    .appendingPathExtension("json")
                if self.fileManager.fileExists(atPath: configPath.path) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        return false
    }
    
    func initBubo() -> Bool {
        if let tDocumentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("BuboProjects")
            if !self.fileManager.fileExists(atPath: filePath.path) {
                do {
                    try self.fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    if self.fileManager.fileExists(atPath: filePath.path) {
                        let configPath = filePath
                            .appendingPathComponent("buborc")
                            .appendingPathExtension("json")
                        if !self.fileManager.fileExists(atPath: configPath.path) {
                            let isCreated = fileManager
                                .createFile(atPath: configPath.path, contents: nil, attributes: nil)
                            if isCreated {
                                NSLog("buborc created at path: \(configPath)")
                            } else {
                                NSLog("ERROR: buborc can't be created at path: \(configPath)")
                                return false
                            }
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
    
    func updateInitStatus(status: Bool) -> Void {
    }
    
    func initNewRepo(name: String) -> Bool {
        var dirName: String = name
        dirName.append("Anchor")
        if let tDocumentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let repoPath =  tDocumentDirectory
                .appendingPathComponent("BuboProjects")
                .appendingPathComponent("\(name)")

            if !self.fileManager.fileExists(atPath: repoPath.path) {
                do {
                    try self.fileManager.createDirectory(atPath: repoPath.path, withIntermediateDirectories: true, attributes: nil)
                    if self.fileManager.fileExists(atPath: repoPath.path) {
                        let configPath = repoPath
                            .appendingPathComponent("anchorrc")
                            .appendingPathExtension("json")
                        if !self.fileManager.fileExists(atPath: configPath.path) {
                            let isCreated = self.fileManager
                                .createFile(atPath: configPath.path, contents: nil, attributes: nil)
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

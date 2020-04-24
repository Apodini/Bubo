 //
 //  Created by Valentin Hartig on 20.04.20.
 //
 
 import Foundation
 
 public struct Buborc: Codable {
    public var version: String
    public var projects: [URL]?
    public var rootRepoUrl: URL?
    public var initialisationDate: String
    
    init(version: String, projects: [URL], rootRepoUrl: URL) {
        self.version = version
        self.projects = projects
        self.rootRepoUrl = rootRepoUrl
        self.initialisationDate = Date().description(with: .current)
    }
    
    init(version: String, projects: [URL]) {
        let fileManager = FileManager()
        var rootPath: URL? = URL(string: fileManager.currentDirectoryPath)
        // Try to get one of the standard root repo locations
        if rootPath == nil {
            NSLog("ERROR: Can't init root repo path")
            rootPath = nil
        } else {
            rootPath = rootPath?.appendingPathComponent("BuboProjects")
        }
        self.version = version
        self.projects = projects
        self.rootRepoUrl = rootPath
        self.initialisationDate = Date().description(with: .current)
    }
 }

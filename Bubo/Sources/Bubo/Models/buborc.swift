 //
 //  Created by Valentin Hartig on 20.04.20.
 //
 
 import Foundation
 
 public struct Buborc: Codable {
    public var version: String
    public var projects: [String:URL]?
    public var rootUrl: URL?
    public var initialisationDate: String
    
    init(version: String, projects: [String:URL], rootRepoUrl: URL) {
        self.version = version
        self.projects = projects
        self.rootUrl = rootRepoUrl
        self.initialisationDate = Date().description(with: .current)
    }
    
    init(version: String, projects: [String:URL]) {
        let fileManager = FileManager()
        var rootPath: URL?
        if #available(OSX 10.12, *) {
             rootPath = fileManager.homeDirectoryForCurrentUser
        } else {
            // Fallback on earlier versions
            rootPath = URL(fileURLWithPath: NSHomeDirectory())
        }
        // Try to get one of the standard root repo locations
        if rootPath == nil {
            errorMessage(msg: "Can't init root repo path")
            rootPath = nil
        } else {
            rootPath = rootPath?.appendingPathComponent(".bubo")
        }
        self.version = version
        self.projects = projects
        self.rootUrl = rootPath
        self.initialisationDate = Date().description(with: .current)
    }
 }

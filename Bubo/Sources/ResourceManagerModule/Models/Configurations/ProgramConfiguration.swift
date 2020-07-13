 //
 //  Created by Valentin Hartig on 20.04.20.
 //
 
 import Foundation
 
 public struct ProgramConfiguration: Codable {
    
    /// The version of the currently used application
    public var version: String
    
    /// A verbose mode that activates or deactivates verbose command line outputs
    public var verboseMode: Bool
    
    /// All projects that the application can work on identified by their project name
    public var projects: [String:URL]?
    
    /// The applications root directory URL where all application configuration files live
    public var rootUrl: URL?
    
    /// The date when the current version of Bubo was initialised
    public var initialisationDate: String
    
    /// The extended constructor to specify a dedicated application root driectory
    public init(version: String, projects: [String:URL], rootRepoUrl: URL) {
        self.version = version
        self.projects = projects
        self.rootUrl = rootRepoUrl
        self.initialisationDate = Date().description(with: .current)
        self.verboseMode = false
    }
    
    /// The standard constructor
    /// Locates the application root directory in the users home directory
    public init(version: String, projects: [String:URL]) {
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
            errorMessage(msg: "Can't initialise root repository in home directory")
            rootPath = nil
        } else {
            rootPath = rootPath?.appendingPathComponent(".bubo")
        }
        self.verboseMode = false
        self.version = version
        self.projects = projects
        self.rootUrl = rootPath
        self.initialisationDate = Date().description(with: .current)
    }
 }

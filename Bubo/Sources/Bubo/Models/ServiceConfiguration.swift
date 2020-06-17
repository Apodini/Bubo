//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation


public struct ServiceConfiguration: Codable, Equatable {
    
    /// The name of the service that acts as a unique identifier for the service
    var name: String
    
    /// The URL where the service is located
    var url: URL
    
    /// The URL where the .git directory is located
    var gitRootURL: URL
    
    /// The URL where the root of the swift package is located
    var packageRootURL: URL?
    
    /// The remote origin URL for the git repository
    var gitRemoteURL: URL
    
    /// The date when the service was cloned
    var dateCloned: String
    
    /// A timestamp for the date the service was last updated
    var lastUpdated: String
    
    /// The hash of the current git commit
    var currentGitHash: String
    
    /// The hash of the commit that was last build
    var currentBuildGitHash: String?
    
    /// A status flag that indicates if the service should be included in global analysis
    var status: Bool
    
    /// All files that belong to the service
    var files: [File]
    
    /// The Package.swift file if it exists
    var packageDotSwift: File?
    
    /// The swift version file if it exists
    var swiftVersion: File?
    
    /// The raw dependency graph of the service if it's been generated
    var graph: DependencyGraph<Node>?
    
    /// The standard constructor
    init(name: String, url: URL, gitURL: URL, currentGitHash: String, currentBuildGitHash: String?, files: [File]) {
        self.name = name
        self.url = url
        self.gitRemoteURL = gitURL
        self.dateCloned = Date().description(with: .current)
        self.lastUpdated = Date().description(with: .current)
        self.status = true
        self.files = files
        self.currentGitHash = currentGitHash
        self.currentBuildGitHash = currentBuildGitHash
        self.graph = nil
        
        var tmpGitRootURL: URL? = nil
        for file in self.files {
            if file.fileName == ".swift-version" {
                self.swiftVersion = file
            }
            if file.fileName == "Package.swift" {
                self.packageDotSwift = file
                tmpGitRootURL = file.fileURL.deletingPathExtension().deletingLastPathComponent()
            }
        }
        if tmpGitRootURL == nil {
            self.gitRootURL = self.url
            self.packageRootURL = nil
        } else {
            self.packageRootURL = tmpGitRootURL!
            self.gitRootURL = tmpGitRootURL!
        }
    }
    
    /// An extended constructor to generate megerged Services
    init(name: String, url: URL, gitURL: URL, currentGitHash: String, currentBuildGitHash: String?, files: [File], dateCloned: String, lastUpdated: String) {
        self.name = name
        self.url = url
        self.gitRemoteURL = gitURL
        self.currentGitHash = currentGitHash
        self.dateCloned = dateCloned
        self.lastUpdated = lastUpdated
        self.status = true
        self.files = files
        self.currentGitHash = currentGitHash
        self.currentBuildGitHash = currentBuildGitHash
        
        var tmpGitRootURL: URL? = nil
        for file in self.files {
            if file.fileName == ".swift-version" {
                self.swiftVersion = file
            }
            if file.fileName == "Package.swift" {
                self.packageDotSwift = file
                tmpGitRootURL = file.fileURL.deletingPathExtension().deletingLastPathComponent()
            }
        }
        if tmpGitRootURL == nil {
            self.gitRootURL = self.url
        } else {
            self.gitRootURL = tmpGitRootURL!
        }
    }
    
    public static func == (lhs: ServiceConfiguration, rhs: ServiceConfiguration) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    /// The setter function for the dependency graph
    ///
    /// - parameter graph: The dependency graph
    
    public mutating func setGraph(graph: DependencyGraph<Node>) -> Void {
        self.graph = graph
    }
}

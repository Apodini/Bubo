//
//  File.swift
//  
//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation


public struct Service: Codable, Equatable {
    var name: String
    var url: URL
    var gitRootURL: URL
    var packageRootURL: URL?
    var gitRemoteURL: URL
    var dateCloned: String
    var lastUpdated: String
    var currentGitHash: String
    var currentBuildGitHash: String?
    var status: Bool // Is the service actively included in analysis?
    var files: [File]
    var packageDotSwift: File?
    var swiftVersion: File?
    var graph: DependencyGraph<Node>?
    
    
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
    
    public static func == (lhs: Service, rhs: Service) -> Bool {
        return lhs.name == rhs.name
    }
    
    public mutating func setGraph(graph: DependencyGraph<Node>) -> Void {
        self.graph = graph
    }
}

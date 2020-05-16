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
    var gitURL: URL
    var dateCloned: String
    var lastPull: String
    var status: Bool // Is the service actively included in analysis?
    var files: [File]
    var packageDotSwift: File?
    var swiftVersion: File?
    
    
    init(name: String, url: URL, gitURL: URL, files: [File]) {
        self.name = name
        self.url = url
        self.gitURL = gitURL
        self.dateCloned = Date().description(with: .current)
        self.lastPull = Date().description(with: .current)
        self.status = true
        self.files = files
        
        for file in self.files {
            if file.fileName == ".swift-version" {
                self.swiftVersion = file
            }
            if file.fileName == "Package.swift" {
                self.packageDotSwift = file
            }
        }
    }
    
    public static func == (lhs: Service, rhs: Service) -> Bool {
        return lhs.name == rhs.name
    }

}

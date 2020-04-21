//
//  File.swift
//  
//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

public struct Buborc: Codable {
    public var version: String
    public var projects: [URL]
    public var rootRepoUrl: URL
    public var initialisationDate: String
    
    init(version: String, projects: [URL], rootRepoUrl: URL, initialisationDate: String) {
        self.version = version
        self.projects = projects
        self.rootRepoUrl = rootRepoUrl
        self.initialisationDate = initialisationDate
    }
}

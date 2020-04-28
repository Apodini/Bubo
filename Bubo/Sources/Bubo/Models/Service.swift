//
//  File.swift
//  
//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation


public struct Service: Codable {
    var url: URL
    var gitURL: URL
    var dateCloned: String
    var lastPull: String
    var status: Bool // Is the service actively included in analysis?
    
    init(url: URL, gitURL: URL) {
        self.url = url
        self.gitURL = gitURL
        self.dateCloned = Date().description(with: .current)
        self.lastPull = Date().description(with: .current)
        self.status = true
    }
}

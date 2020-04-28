//
//  Created by Valentin Hartig on 21.04.20.
//

import Foundation

struct Anchorrc: Codable {
    public var url: URL
    public var projectName: String // Name of the Project
    public var creator: String
    public var creationTimestamp: String
    public var repositories: [String:Service]
    public var lastUpdated: String
    
    init(url: URL, projectName: String, creator: String, lastUpdated: String) {
        self.creationTimestamp = Date().description(with: .current)
        self.creator = creator
        self.lastUpdated = lastUpdated
        self.projectName = projectName
        self.repositories = [:]
        self.url = url
    }
}

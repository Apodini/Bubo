//
//  Created by Valentin Hartig on 21.04.20.
//

import Foundation

struct ProjectConfiguration: Codable {
    
    /// The URL where the project is located
    public var url: URL
    
    /// The project name  that works as a unique idetifier for the project
    public var projectName: String
    
    /// A timestamp for the creation of the project
    public var creationTimestamp: String
    
    /// A timestamp for the last time the project was updated or changed by the program
    public var lastUpdated: String
    
    /// All services of this project identified by thier service name
    public var repositories: [String:ServiceConfiguration]

    
    init(url: URL, projectName: String, lastUpdated: String) {
        self.creationTimestamp = Date().description(with: .current)
        self.lastUpdated = lastUpdated
        self.projectName = projectName
        self.repositories = [:]
        self.url = url
    }
}

//
//  Created by Valentin Hartig on 13.07.20.
//

import Foundation
import ShellOut
import GraphBuilderModule
import ResourceManagerModule


public class StructuralAnalyser {
    
    public let fileManager: FileManager  = FileManager.default
    public var graphBuilder: GraphBuilder?
    public var service: ServiceConfiguration
    public var mostRecentGraphSnapshot: GraphSnapshot?
    public let projectName: String
    public let resourceManager: ResourceManager = ResourceManager()
    
    
    public init(service: ServiceConfiguration, pName: String) {
        // Init properties
        self.service = service
        self.mostRecentGraphSnapshot = nil
        self.graphBuilder = nil
        self.projectName = pName
    }
}

//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut
import ResourceManagerModule


public class ServiceManager {
    public let fileManager: FileManager  = FileManager.default
    private var service: ServiceConfiguration
    private var projectName: String
    private let resourceManager: ResourceManager = ResourceManager()
    public var structuralAnalyser: StructuralAnalyser
    
    
    public init(service: ServiceConfiguration, pName: String?) {
        // Init properties
        self.service = service
        guard let name = pName else {
            errorMessage(msg: "Can't unwrap project name!")
            self.projectName = ""
            self.structuralAnalyser = StructuralAnalyser(service: service, pName: "")
            return
        }
        self.projectName = name
        self.structuralAnalyser = StructuralAnalyser(service: service, pName: name)
    }
    
}

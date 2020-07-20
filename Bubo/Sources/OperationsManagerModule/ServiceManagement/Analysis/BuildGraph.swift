//
//  Created by Valentin Hartig on 19.07.20.
//

import Foundation
import ResourceManagerModule
import ServiceAnalyserModule

extension OperationsManager {
    
    public func buildGraph(projectName: String?, serviceName: String) -> Void {
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard var (projectHandle, projectConfig) = self.resourceManager.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Building Graph for \(serviceName)")
            return
        }
        
        /// Fetch service configuration
        guard let (_,serviceConfig) = self.resourceManager.decodeServiceConfig(pName: projectName, serviceName: serviceName) else {
            abortMessage(msg: "Building Graph for \(serviceName)")
            return
        }
        
        let serviceManager = ServiceManager(service: serviceConfig, pName: projectHandle)
        guard serviceManager.structuralAnalyser.createDependencyGraph() != nil else {
            return
        }
    }

}

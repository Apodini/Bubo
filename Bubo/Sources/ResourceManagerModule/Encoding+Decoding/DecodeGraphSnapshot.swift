//
//  Created by Valentin Hartig on 07.07.20.
//

import Foundation
import GraphBuilderModule


extension ResourceManager {
    
    /// Decodes a project configuration based on a project name
    ///
    /// - parameter projectName: The name of the project. If `projectName` is nil, the program checks if the current directory name is a project.
    /// - returns: The validated project handle and the project configuration data
    
    public func decodeAllGraphSnapshots(pName: String?, serviceName: String) -> (projectHandle: String, graphSnapshots: [GraphSnapshot])? {
        
        /// Validates the project name and fetches the `projectHandle` and the `projectURL`
        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: pName) else {
            abortMessage(msg: "Refresh services")
            return nil
        }
        
        /// Checks if a configuration at the project configuration path exists and trys to decode it
        let configURL = projectURL.appendingPathComponent("projectConfiguration").appendingPathExtension("json")
        let fileURL = URL(fileURLWithPath: configURL.path)
        guard let projectConfig: ProjectConfiguration = decodeProjectConfigfromJSON(url: fileURL) else {
            return nil
        }
        
        if projectConfig.repositories.keys.contains(serviceName) {
           
            let serviceConfigURL: URL = URL(fileURLWithPath:projectConfig.url.appendingPathComponent("\(serviceName)_Configuration").appendingPathExtension("json").path)
            
            guard let serviceConfig: ServiceConfiguration = decodeServiceConfigfromJSON(url: serviceConfigURL) else {
                errorMessage(msg: "Can't decode service \(serviceName) at url \(serviceConfigURL.path)")
                abortMessage(msg: "Decoding service configuration")
                return nil
            }
            var graphSnapshots: [GraphSnapshot] = [GraphSnapshot]()
            for snapshotURL in serviceConfig.graphSnapshots {
                if let graphSnapshot: GraphSnapshot = decodeGraphSnapshotfromJSON(url: snapshotURL)  {
                    graphSnapshots.append(graphSnapshot)
                }
            }
            return (projectHandle, graphSnapshots)
            
        } else {
            errorMessage(msg: "No service with name \(serviceName)")
            return nil
        }
    }
}

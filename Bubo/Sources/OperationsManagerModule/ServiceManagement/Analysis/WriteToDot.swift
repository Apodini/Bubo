//
//  Created by Valentin Hartig on 13.07.20.
//

import Foundation
import GraphBuilderModule
import ResourceManagerModule

extension OperationsManager {
    public func writeToDot(projectName: String?, serviceName: String) -> Void {
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
        outputMessage(msg: "Writing graph to .dot output file and saving it in project directory")
        
        
        var url: URL = URL(fileURLWithPath: projectConfig.url
            .appendingPathComponent("output").path)
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
                
            } catch {
                errorMessage(msg: "Couldn't create output directory")
                return
            }
        }
        
        url = url
            .appendingPathComponent(serviceConfig.name)
            .appendingPathExtension("dot")
        guard let mostRecentGraphSnapshot = resourceManager.getMostRecentGraphSnapshot(service: serviceConfig) else {
            errorMessage(msg: "Couldn't get most recent graph snapshot")
            abortMessage(msg: "Writing to dot")
            return
        }
        
        fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        
        do {
            try mostRecentGraphSnapshot.graph.description.write(to: url, atomically: false, encoding: .utf8)
            successMessage(msg: "Graph output is at \(url.path)")
        } catch {
            warningMessage(msg: "Couldn't write graph to dot file")
            print("ERROR INFO: \(error)")
        }
    }
}

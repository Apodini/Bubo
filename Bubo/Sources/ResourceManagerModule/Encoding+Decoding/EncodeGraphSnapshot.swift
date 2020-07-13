//
//  Created by Valentin Hartig on 07.07.20.
//


import Foundation
import GraphBuilderModule

extension ResourceManager {
    
    /// Encodes passed service configuration data for a project
    ///
    /// - parameters:
    ///     - pName: The project name
    ///     - configData: The configuration data that should be encoded for the project
    
    public func encodeGraphSnapshot(pName: String?, serviceName: String, graphSnapshot: GraphSnapshot) -> URL? {
        
        /// Fetch projects and validate project name
        guard let (_, projectConfig) = self.decodeProjectConfig(pName: pName) else {
            abortMessage(msg: "Encoding of graph snapshot")
            return nil
        }
        
        guard let serviceURL: URL = projectConfig.repositories[serviceName] else {
            errorMessage(msg: "Can't encode graph snapshot because the service cant be found!")
            return nil
        }
        
        /// Fetch the projects configuration file URL
        let snapshotURL: URL = serviceURL.deletingPathExtension().deletingLastPathComponent().appendingPathComponent("\(graphSnapshot.buildGitHash)").appendingPathExtension("json")
        
        /// Encode the configuration data to JSON
        guard let encode = encodeDataToJSON(config: graphSnapshot) else {
            abortMessage(msg: "Encoding of graph snapshot")
            return nil
        }
        
        /// Remove the current configuration file and create the nwe configuration file
        let snapshotFileURL = URL(fileURLWithPath: snapshotURL.path)
        if fileManager.fileExists(atPath: snapshotFileURL.path) {
            do {
                try fileManager.removeItem(at: snapshotFileURL)
            } catch {
                errorMessage(msg: "Can't remove graph snapshot at path \(snapshotFileURL.path)")
            }
        }
        let isCreated = fileManager.createFile(atPath: snapshotFileURL.path, contents: encode, attributes: nil)
        if !isCreated {
            errorMessage(msg: "Graph snapshot can't be overwritten at path: \(snapshotFileURL.path)")
            return nil
        } else {
            return snapshotFileURL
        }
    }
}

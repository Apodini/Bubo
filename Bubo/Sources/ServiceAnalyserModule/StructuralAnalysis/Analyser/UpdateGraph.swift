//
//  Created by Valentin Hartig on 13.07.20.
//

import Foundation
import GraphBuilderModule
import ResourceManagerModule

extension StructuralAnalyser {
    public func updateGraph() -> Void {
        guard let gb = self.graphBuilder else {
            errorMessage(msg: "Can't access graphbuilder because it hasn't been initialised!")
            return
        }
        
        let graphsnapshot: GraphSnapshot = GraphSnapshot(timestamp: Date().description(with: .current), buildGitHash: service.currentGitHash, graph: gb.graph)
        
        if let url = self.resourceManager.encodeGraphSnapshot(pName: projectName, serviceName: service.name, graphSnapshot: graphsnapshot) {
            if self.resourceManager.encodeServiceConfig(pName: projectName, configData: self.service) != nil {
                self.service.addGraphSnapshot(url: url)
                self.mostRecentGraphSnapshot = graphsnapshot
            } else {
                abortMessage(msg: "Graph snapshot creation")
            }
        } else {
            errorMessage(msg: "Failed to update service: No url for encoded snapshot returned!")
        }
    }
}

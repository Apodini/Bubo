//
//  Created by Valentin Hartig on 13.07.20.
//

import Foundation
import GraphBuilderModule
import ResourceManagerModule

extension StructuralAnalyser {
    public func updateGraph() -> Void {
        let graphsnapshot: GraphSnapshot = GraphSnapshot(timestamp: Date().description(with: .current), buildGitHash: service.currentGitHash, graph: graphBuilder!.graph)
        
        if let url = self.resourceManager.encodeGraphSnapshot(pName: projectName, serviceName: service.name, graphSnapshot: graphsnapshot) {
            self.service.addGraphSnapshot(url: url)
            self.resourceManager.encodeServiceConfig(pName: projectName, configData: self.service)
            self.mostRecentGraphSnapshot = graphsnapshot
        } else {
            errorMessage(msg: "Failed to update service: No url for encoded snapshot returned!")
        }
    }
}

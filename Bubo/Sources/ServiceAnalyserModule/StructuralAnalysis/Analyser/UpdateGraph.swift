//
//  UpdateGraph.swift
//  Bubo
//
//  Created by Valentin Hartig on 13/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import GraphBuilderModule
import ResourceManagerModule


// MARK: StructuralAnalyser
extension StructuralAnalyser {
    
    // Update the dependency graph of tthe service registered in StructuralAnalyser --> generate a new graphSnapshot
    public func updateGraph() -> Void {
        guard let gb = self.graphBuilder else {
            errorMessage(msg: "Can't access graphbuilder because it hasn't been initialised!")
            return
        }
        
        let graphsnapshot: GraphSnapshot = GraphSnapshot(timestamp: Date().description(with: .current), buildGitHash: service.currentGitHash, graph: gb.graph)
        
        if let url = self.resourceManager.encodeGraphSnapshot(pName: projectName, serviceName: service.name, graphSnapshot: graphsnapshot) {
            self.service.addGraphSnapshot(url: url)
            if self.resourceManager.encodeServiceConfig(pName: projectName, configData: self.service) != nil {
                self.mostRecentGraphSnapshot = graphsnapshot
            } else {
                abortMessage(msg: "Graph snapshot creation")
            }
        } else {
            errorMessage(msg: "Failed to update service: No url for encoded snapshot returned!")
        }
    }
}

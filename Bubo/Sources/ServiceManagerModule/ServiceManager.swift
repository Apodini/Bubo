//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut
import GraphBuilderModule
import ResourceManagerModule


public class ServiceManager {
    public let fileManager: FileManager  = FileManager.default
    private var graphBuilder: GraphBuilder?
    private var service: ServiceConfiguration
    private var mostRecentGraphSnapshot: GraphSnapshot?
    private let projectName: String
    private let resourceManager: ResourceManager = ResourceManager()
    
    
    public init(service: ServiceConfiguration, pName: String?) {
        // Init properties
        self.service = service
        self.mostRecentGraphSnapshot = nil
        self.graphBuilder = nil
        guard let name = pName else {
            errorMessage(msg: "Can't unwrap project name!")
            self.projectName = ""
            return
        }
        self.projectName = name
    }
    
    
    public func createDependencyGraph() -> RefinedDependencyGraph<Node>? {
        // Build service
        headerMessage(msg: "Checking Graph...")
        self.mostRecentGraphSnapshot = resourceManager.getMostRecentGraphSnapshot(service: service)

        if !self.compareGitHash() || mostRecentGraphSnapshot == nil{
            outputMessage(msg: "Graph needs to be updated")
            self.cleanUpService()
            self.buildService()
            
            // Init graph builder service
            self.graphBuilder = GraphBuilder(service: service)
            
            self.graphBuilder!.generateRefinedDependencyGraph()
            self.updateGraph()
            successMessage(msg: "Graph successfully updated!")
            return self.graphBuilder!.graph
        } else {
            successMessage(msg: "Graph is up to date!")
            self.graphBuilder = GraphBuilder(service: service)
            self.graphBuilder?.graph = mostRecentGraphSnapshot!.graph
            return mostRecentGraphSnapshot!.graph
        }
    }
    
    private func updateGraph() -> Void {
        let graphsnapshot: GraphSnapshot = GraphSnapshot(timestamp: Date().description(with: .current), buildGitHash: service.currentGitHash, graph: graphBuilder!.graph)
        
        if let url = self.resourceManager.encodeGraphSnapshot(pName: projectName, serviceName: service.name, graphSnapshot: graphsnapshot) {
            self.service.addGraphSnapshot(url: url)
            self.resourceManager.encodeServiceConfig(pName: projectName, configData: self.service)
            self.mostRecentGraphSnapshot = graphsnapshot
        } else {
            errorMessage(msg: "Failed to update service: No url for encoded snapshot returned!")
        }
    }
    
    
    private func compareGitHash() -> Bool {
        
        guard let snapshot = mostRecentGraphSnapshot else {
            return false
        }
        
        return service.currentGitHash == snapshot.buildGitHash
    }
    
    private func buildService() -> Void {
        headerMessage(msg: "Initialising building process...")
        if let packageDotSwiftURL = service.packageDotSwift?.fileURL {
            if self.fileManager.changeCurrentDirectoryPath(
                packageDotSwiftURL
                    .deletingPathExtension()
                    .deletingLastPathComponent()
                    .path
                ) {
                do {
                    try shellOut(to: .buildSwiftPackage())
                    successMessage(msg: "Build for service \(service.name) completed")
                } catch {
                    let error = error as! ShellOutError
                    errorMessage(msg: "Failed to build \(service.name). Can't index service if it's not build")
                    warningMessage(msg: error.message) // Prints STDERR
                    warningMessage(msg: error.output) // Prints STDOUT
                }
            }
        } else {
            warningMessage(msg: "Couldn't locate package.swift and therefore not build \(service.name). Indexing is not possible and therefor no graph will be geneerated")
        }
    }
    
    private func cleanUpService() -> Void {
        headerMessage(msg: "Cleaning up service...")
        if self.fileManager.fileExists(atPath: service.gitRootURL.appendingPathComponent(".build").path) {
            if self.fileManager.changeCurrentDirectoryPath(service.gitRootURL.path) {
                do {
                    try self.fileManager.removeItem(at: service.gitRootURL.appendingPathComponent(".build"))
                    successMessage(msg: "Removed .build directory from \(service.name)")
                } catch {
                    errorMessage(msg: "Failed to remove .build directory from \(service.name)")
                }
            }
        }
    }
    
    public func writeToDot() -> Void {
        outputMessage(msg: "Writing graph to .dot output file and saving it in project directory")
        
        guard let (_, projectConfig) = self.resourceManager.decodeProjectConfig(pName: projectName) else {
            errorMessage(msg: "Couldn't write graph to .dot file because the project confidguration cannot be decoded!")
            return
        }
        
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
            .appendingPathComponent(service.name)
            .appendingPathExtension("dot")
        
        fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        
        do {
            try mostRecentGraphSnapshot!.graph.description.write(to: url, atomically: false, encoding: .utf8)
            successMessage(msg: "Graph output is at \(url.path)")
        } catch {
            warningMessage(msg: "Couldn't write graph to dot file")
            print("ERROR INFO: \(error)")
        }
    }
}

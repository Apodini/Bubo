//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut

class ServiceManager {
    public let fileManager: FileManager  = FileManager.default
    private let resourceManager: ResourceManager = ResourceManager()
    public let parser: Parser
    private var graphBuilder: GraphBuilder?
    private var service: ServiceConfiguration
    private let projectName: String
    
    
    init(service: ServiceConfiguration, pName: String?) {
        // Init properties
        self.service = service
        self.parser = Parser()
        self.graphBuilder = nil
        
        guard let name = pName else {
            errorMessage(msg: "Can't unwrap project name!")
            self.projectName = ""
            return
        }
        self.projectName = name
    }
    
    
    public func createDependencyGraph() -> DependencyGraph<Node>? {
        // Build service
        outputMessage(msg: "Checking Graph...")
        if !self.compareGitHash() || service.graph == nil{
            outputMessage(msg: "Graph needs to be updated")
            self.cleanUpService()
            self.buildService()
            
            // Parse service
            parser.parse(service: service)
            self.graphBuilder = GraphBuilder(tokens: parser.tokens, tokenExtensions: parser.tokenExtensions, service: service)
            
            
            self.graphBuilder!.generateRawGraph()
            self.updateGraph()
            successMessage(msg: "Graph successfully updated!")
            return self.graphBuilder!.graph
        } else {
            successMessage(msg: "Graph is up to date!")
            self.graphBuilder = GraphBuilder(tokens: parser.tokens, tokenExtensions: parser.tokenExtensions, service: service)
            self.graphBuilder?.graph = service.graph!
            return service.graph!
        }
    }
    
    public func clusterGraphByClasses() -> [DependencyGraph<Node>]? {
        guard let graph = createDependencyGraph() else {
            errorMessage(msg: "Failed to create graph")
            abortMessage(msg: "Aborting class clustering")
            return nil
        }
        return graphBuilder!.clusterByClasses(originalGraph: graph)
    }
    
    private func updateGraph() -> Void {
        var updatedService: ServiceConfiguration = ServiceConfiguration(
            name: service.name,
            url: service.url,
            gitURL: service.gitRemoteURL,
            currentGitHash: service.currentGitHash,
            currentBuildGitHash: service.currentGitHash,
            files: service.files)
        updatedService.setGraph(graph: self.graphBuilder!.graph)
        self.service = updatedService
        self.resourceManager.encodeServiceConfig(pName: projectName, configData: updatedService)
    }
    
    
    private func compareGitHash() -> Bool {
        
        guard let buildHash = service.currentBuildGitHash else {
            // Update project configuration with new build hash
            let updatedService: ServiceConfiguration = ServiceConfiguration(
                name: service.name,
                url: service.url,
                gitURL: service.gitRemoteURL,
                currentGitHash: service.currentGitHash,
                currentBuildGitHash: service.currentGitHash,
                files: service.files)
            self.service = updatedService
            self.resourceManager.encodeServiceConfig(pName: projectName, configData: updatedService)
            return false
        }
        
        if service.currentGitHash == buildHash {
            return true
        } else {
            let updatedService: ServiceConfiguration = ServiceConfiguration(
                name: service.name,
                url: service.url,
                gitURL: service.gitRemoteURL,
                currentGitHash: service.currentGitHash,
                currentBuildGitHash: service.currentGitHash,
                files: service.files)
            self.service = updatedService
            
            self.resourceManager.encodeServiceConfig(pName: projectName, configData: updatedService)
            return false
        }
    }
    
    private func buildService() -> Void {
        outputMessage(msg: "Initialising building process...")
        if let packageDotSwiftURL = service.packageDotSwift?.fileURL {
            if self.fileManager.changeCurrentDirectoryPath(
                packageDotSwiftURL
                    .deletingPathExtension()
                    .deletingLastPathComponent()
                    .path
                ) {
                do {
                    try shellOut(to: .buildSwiftPackage())
                    outputMessage(msg: "Build for service \(service.name) completed")
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
        outputMessage(msg: "Cleaning up service...")
        if self.fileManager.fileExists(atPath: service.gitRootURL.appendingPathComponent(".build").path) {
            if self.fileManager.changeCurrentDirectoryPath(service.gitRootURL.path) {
                do {
                    try self.fileManager.removeItem(at: service.gitRootURL.appendingPathComponent(".build"))
                    outputMessage(msg: "Removed .build directory from \(service.name)")
                } catch {
                    errorMessage(msg: "Failed to remove .build directory from \(service.name)")
                }
            }
        }
    }
    
    public func writeToDot() -> Void {
        outputMessage(msg: "Writing graph to .dot output file and saving it in project directory")
        
        guard let (projectName, projectConfig) = resourceManager.decodeProjectConfig(pName: projectName) else {
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
            try service.graph!.description.write(to: url, atomically: false, encoding: .utf8)
            successMessage(msg: "Graph output is at \(url.path)")
        } catch {
            warningMessage(msg: "Couldn't write graph to dot file")
            print("ERROR INFO: \(error)")
        }
    }
}

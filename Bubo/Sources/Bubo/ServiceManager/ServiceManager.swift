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
    private let service: ServiceConfiguration
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

            
            self.graphBuilder!.createDependencyGraph()
            self.updateGraph()
            successMessage(msg: "Graph successfully updated!")
            return self.graphBuilder!.graph
        } else {
            successMessage(msg: "Graph is up to date!")
            return service.graph!
        }
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
}

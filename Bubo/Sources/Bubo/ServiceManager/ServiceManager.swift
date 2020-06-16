//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut

class ServiceManager {
    public static let fileManager: FileManager  = FileManager.default
    private static let resourceManager: ResourceManager = ResourceManager()
    public let parser: Parser
    private let graphBuilder: GraphBuilder
    private let service: Service
    private let projectName: String
    
    
    init(service: Service, pName: String?) {
        // Init properties
        self.service = service
        self.parser = Parser()
        
        // Build service
        if !ServiceManager.compareGitHash(service: service, pName: pName) {
            ServiceManager.cleanUpService(service: service)
            ServiceManager.buildService(service: service)
        }
        
        // Parse service + build graph
        parser.parse(service: service)
        self.graphBuilder = GraphBuilder(tokens: parser.tokens, tokenExtensions: parser.tokenExtensions, service: service)
        
        guard let name = pName else {
            errorMessage(msg: "Can't unwrap project name!")
            self.projectName = ""
            return
        }
        self.projectName = name
    }
    
    
    
    private static func compareGitHash(service: Service, pName: String?) -> Bool {
        guard var (projectHandle, projectConfig) = self.resourceManager.decodeProjectConfig(pName: pName) else {
            abortMessage(msg: "Refresh services")
            return false
        }
        
        guard let buildHash = service.currentBuildGitHash else {
            // Update project configuration with new build hash
            var services = projectConfig.repositories
            let updatedService: Service = Service(
                name: service.name,
                url: service.url,
                gitURL: service.gitRemoteURL,
                currentGitHash: service.currentGitHash,
                currentBuildGitHash: service.currentGitHash,
                files: service.files)
            services[updatedService.name] = updatedService
            projectConfig.repositories = services
            projectConfig.lastUpdated = Date().description(with: .current)
            self.resourceManager.encodeProjectConfig(pName: projectHandle, configData: projectConfig)
            return false
        }
        
        if service.currentGitHash == buildHash {
            return true
        } else {
            var services = projectConfig.repositories
            let updatedService: Service = Service(
                name: service.name,
                url: service.url,
                gitURL: service.gitRemoteURL,
                currentGitHash: service.currentGitHash,
                currentBuildGitHash: service.currentGitHash,
                files: service.files)
            services[updatedService.name] = updatedService
            projectConfig.repositories = services
            projectConfig.lastUpdated = Date().description(with: .current)
            self.resourceManager.encodeProjectConfig(pName: projectHandle, configData: projectConfig)
            successMessage(msg: "Reencoded projectconfig")
            return false
        }
    }
    
    private static func buildService(service: Service) -> Void {
        outputMessage(msg: "Initialising building process...")
        if let packageDotSwiftURL = service.packageDotSwift?.fileURL {
            if ServiceManager.fileManager.changeCurrentDirectoryPath(
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
    
    private static func cleanUpService(service: Service) -> Void {
        outputMessage(msg: "Cleaning up service...")
        if ServiceManager.fileManager.fileExists(atPath: service.gitRootURL.appendingPathComponent(".build").path) {
            if ServiceManager.fileManager.changeCurrentDirectoryPath(service.gitRootURL.path) {
                do {
                    try ServiceManager.fileManager.removeItem(at: service.gitRootURL.appendingPathComponent(".build"))
                    outputMessage(msg: "Removed .build directory from \(service.name)")
                } catch {
                    errorMessage(msg: "Failed to remove .build directory from \(service.name)")
                }
            }
        }
    }
    public func createDependencyGraph() -> DependencyGraph<Node>? {
        graphBuilder.createDependencyGraph()
        self.updateGraph()
        return graphBuilder.graph
    }
    
    private func updateGraph() -> Void {
        guard var (projectHandle, projectConfig) = ServiceManager.resourceManager.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Refresh services")
            return
        }
        
        var services = projectConfig.repositories
        var updatedService: Service = Service(
            name: service.name,
            url: service.url,
            gitURL: service.gitRemoteURL,
            currentGitHash: service.currentGitHash,
            currentBuildGitHash: service.currentGitHash,
            files: service.files)
        updatedService.setGraph(graph: graphBuilder.graph)
        services[updatedService.name] = updatedService
        projectConfig.repositories = services
        projectConfig.lastUpdated = Date().description(with: .current)
        ServiceManager.resourceManager.encodeProjectConfig(pName: projectHandle, configData: projectConfig)
    }
}

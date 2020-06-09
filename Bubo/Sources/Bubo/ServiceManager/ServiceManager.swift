//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut

class ServiceManager {
    public static let fileManager: FileManager  = FileManager.default;
    
    private let resourceManager: ResourceManager;
    public let parser: Parser
    private let graphBuilder: GraphBuilder
    private let service: Service
    
    
    init(service: Service) {
        // Init properties
        self.service = service
        self.resourceManager = ResourceManager()
        self.parser = Parser()
        
        // Build service
        ServiceManager.buildService(service: service)
        
        // Parse service + build graph
        parser.parse(service: service)
        self.graphBuilder = GraphBuilder(tokens: parser.tokens, service: service)
    }
    
    deinit {
        outputMessage(msg: "Cleaning up service...")
        if let rootURL = service.packageDotSwift?.fileURL.deletingPathExtension().deletingLastPathComponent() {
            if ServiceManager.fileManager.changeCurrentDirectoryPath(rootURL.path) {
                do {
                    try ServiceManager.fileManager.removeItem(at: rootURL.appendingPathComponent(".build"))
                    outputMessage(msg: "Removed .build directory from \(service.name)")
                } catch {
                    errorMessage(msg: "Failed to remove .build directory from \(service.name)")
                }
            }
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
    public func createDependencyGraph() -> DependencyGraph<Node>? {
        graphBuilder.createDependencyGraph()
        return graphBuilder.graph
    }
}

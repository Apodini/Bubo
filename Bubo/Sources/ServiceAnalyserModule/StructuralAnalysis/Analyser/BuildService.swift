//
//  File.swift
//  
//
//  Created by Valentin Hartig on 13.07.20.
//

import Foundation
import GraphBuilderModule
import ResourceManagerModule
import ShellOut

extension StructuralAnalyser {
    public func buildService() -> Void {
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
}

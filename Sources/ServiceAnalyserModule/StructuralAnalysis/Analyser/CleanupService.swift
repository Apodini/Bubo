//
//  CleanupService.swift
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
    
    /// Purde all build data for the service registered in StructuralAnalyser
    public func cleanUpService() -> Void {
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
}

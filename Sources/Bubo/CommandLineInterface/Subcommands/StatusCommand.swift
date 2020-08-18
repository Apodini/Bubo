//
//  StatusCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 04/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ArgumentParser
import ResourceManagerModule


// MARK: Status
extension Bubo {
    
    /// **Subcommand**: Get the statistics and status information about the application
    struct Status: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Shows the current status of Bubo")
        
        @Flag(name: .long, help: "Activate / Deactivate verbose mode for Bubo")
        var verbose: Bool
        
        func makeBold(string: String) -> String {
            return string .bold()
        }
        
        func run() {
            if verbose {
                Main.operationsManager.resourceManager.rootConfig.verboseMode = !Main.operationsManager.resourceManager.rootConfig.verboseMode
                Main.operationsManager.resourceManager.encodeRootConfig(config: Main.operationsManager.resourceManager.rootConfig) // persist change in root config
            }
            let colorBubo = "Bubo" .blue()
            headerMessage(msg: "Status of \(colorBubo) root configuration \n".underline())
            print("\(makeBold(string: "Initialisation Status")): \(Main.operationsManager.resourceManager.initStatus)")
            print("\(makeBold(string: "Initialisation Date")): \(Main.operationsManager.resourceManager.rootConfig.initialisationDate)")
            print("\(makeBold(string: "Version")): \(Main.operationsManager.resourceManager.rootConfig.version)")
            print("\(makeBold(string: "Verbose")): \(Main.operationsManager.resourceManager.rootConfig.verboseMode)")
            print("\(makeBold(string: "Location")): \(Main.operationsManager.resourceManager.rootConfig.rootUrl?.path ?? "None")")
            print("\(makeBold(string: "Number of Projects")): \(Main.operationsManager.resourceManager.rootConfig.projects?.count ?? 0)")
        }
    }
}

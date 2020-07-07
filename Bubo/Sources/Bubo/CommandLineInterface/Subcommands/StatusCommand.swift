//
//  Created by Valentin Hartig on 04.05.20.
//

import Foundation
import ArgumentParser
import OutputStylingModule
import BuboModelsModule


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
                Main.resourceManager.rootConfig.verboseMode = !Main.resourceManager.rootConfig.verboseMode
                Main.resourceManager.encodeRootConfig(config: Main.resourceManager.rootConfig) // persist change in root config
            }
            let colorBubo = "Bubo" .blue()
            headerMessage(msg: "Status of \(colorBubo) root configuration \n".underline())
            print("\(makeBold(string: "Initialisation Status")): \(Main.resourceManager.initStatus)")
            print("\(makeBold(string: "Initialisation Date")): \(Main.resourceManager.rootConfig.initialisationDate)")
            print("\(makeBold(string: "Version")): \(Main.resourceManager.rootConfig.version)")
            print("\(makeBold(string: "Verbose")): \(Main.resourceManager.rootConfig.verboseMode)")
            print("\(makeBold(string: "Location")): \(Main.resourceManager.rootConfig.rootUrl?.path ?? "None")")
            print("\(makeBold(string: "Number of Projects")): \(Main.resourceManager.rootConfig.projects?.count ?? 0)")
        }
    }
}

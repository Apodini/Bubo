//
//  Created by Valentin Hartig on 04.05.20.
//

import Foundation
import ArgumentParser

extension Bubo {
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
                rootConfig.verbose = !rootConfig.verbose
                let fileManagement = FileManagement()
                fileManagement.encodeRootConfig(configFile: rootConfig) // persist change in root config
            }
            let colorBubo = "Bubo" .blue()
            headerMessage(msg: "Status of \(colorBubo) root configuration \n".underline())
            print("\(makeBold(string: "Initialisation Status")): \(initStatus)")
            print("\(makeBold(string: "Initialisation Date")): \(rootConfig.initialisationDate)")
            print("\(makeBold(string: "Version")): \(rootConfig.version)")
            print("\(makeBold(string: "Verbose")): \(rootConfig.verbose)")
            print("\(makeBold(string: "Location")): \(rootConfig.rootUrl?.path ?? "None")")
            print("\(makeBold(string: "Number of Projects")): \(rootConfig.projects?.count ?? 0)")
        }
    }
}

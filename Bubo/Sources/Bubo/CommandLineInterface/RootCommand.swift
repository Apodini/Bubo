//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import ColorizeSwift
import Foundation

// Main command
struct Bubo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Bubo is a tool to aid developers with the decomposiotion of systems into microservices.",
        subcommands: [
            New.self,
            AddService.self,
            List.self,
            ListServices.self,
            UpdateServices.self,
            Remove.self,
            RemoveService.self,
            Open.self,
            Pull.self,
    ])
    
    // Display bubo version with --version
    @Flag(help: "Display current verison of Bubo.")
    var version: Bool
    
    // Display bubo initstatus with --initialisation
    @Flag(help: "Display initialisation status.")
    var status: Bool
    
    // Display bubo initstatus with --initialisation
    // @Flag(help: "Display initialisation status.")
    // var verbose: Bool
    
    func run() throws {
        if version {
            print("Version: \(versionNumber)".bold())
        }
        if status {
            print(" InitStatus: \(initStatus) ".black() .backgroundColor(.green))
            
        }
        // if verbose {
        //       globalVerbose = !globalVerbose
        //  }
        print("Please refer to Bubo -h for more information".bold())
    }
}

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
    subcommands: [New.self])
    
    // Display bubo version with --version
    @Flag(help: "Display current Verison of Bubo")
    var version: Bool
    
    // Display bubo initstatus with --initialisation
    @Flag(help: "Display initialisation status")
    var initialisation: Bool
    
    func run() throws {
        if version {
            print("Version: \(versionNumber)".bold())
        }
        if initialisation {
            print(" InitStatus: \(initStatus) ".black() .backgroundColor(.green))

        }
        print("Please refer to Bubo -h for more information".bold())
    }
}

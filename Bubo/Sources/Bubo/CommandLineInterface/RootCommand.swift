//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import ColorizeSwift
import Foundation

// Main command
struct Bubo: ParsableCommand {
    
    /// **Subcommand**:  The root command of the application that contains all subcommands and defines the option groups
    static let configuration = CommandConfiguration(
        abstract: "Bubo is a tool to aid developers with the decomposiotion of systems into microservices",
        subcommands: [
            Status.self,
            New.self,
            List.self,
            Remove.self,
            Open.self,
            Service.self,
            Analysis.self
    ])
    struct Options: ParsableArguments {
        @Argument(help: "The name of the service living inside the Bubo project")
        var serviceName: String
        
        @Option(name: [.customShort("n"), .long], help: "The name of the Bubo project")
        var projectName: String?
    }
    
    struct OptionsPNonly: ParsableArguments {
        @Option(name: [.customShort("n"), .long], help: "The name of the Bubo project")
        var projectName: String?
    }
}





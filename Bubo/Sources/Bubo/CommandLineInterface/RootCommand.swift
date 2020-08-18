//
//  RootCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 21/04/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import ArgumentParser
import ColorizeSwift
import Foundation


// MARK: - Bubo
/// This is the Root Command of Bubo. All subcommands are registered here
struct Bubo: ParsableCommand {
    
    /// **Subcommand**:  The root command of the application that contains all subcommands and defines the option groups
    static let configuration = CommandConfiguration(
        abstract: "Bubo is a tool to aid developers with the decomposiotion of systems into microservices",
        subcommands: [
            Status.self,
            New.self,
            List.self,
            Remove.self,
            Register.self,
            Open.self,
            Service.self
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





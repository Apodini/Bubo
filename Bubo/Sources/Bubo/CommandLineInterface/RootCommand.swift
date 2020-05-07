//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import ColorizeSwift
import Foundation

// Main command
struct Bubo: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        abstract: "Bubo is a tool to aid developers with the decomposiotion of systems into microservices",
        subcommands: [
            Status.self,
            New.self,
            List.self,
            Remove.self,
            Open.self,
            Service.self
    ])
}



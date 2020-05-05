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
            AddService.self,
            List.self,
            ListServices.self,
            UpdateServices.self,
            Remove.self,
            RemoveService.self,
            Open.self,
            Pull.self,
    ])
    
    
    
    func run() throws {
        print("Please refer to Bubo -h for more information".bold())
    }
}



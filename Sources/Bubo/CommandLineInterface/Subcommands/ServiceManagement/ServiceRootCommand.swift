//
//  ServiceRootCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 06/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ArgumentParser


// MARK: Service
extension Bubo {
    
    /// **Subcommand**: Root for all service based subcommands
    struct Service: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "All actions performed on services of a specific project",
            subcommands: [
                Add.self,
                List.self,
                Pull.self,
                Refresh.self,
                Remove.self,
                Analyse.self
        ])
    }
}

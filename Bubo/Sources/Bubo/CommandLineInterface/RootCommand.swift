//
//  File.swift
//  
//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import ShellOut
import Foundation

// Main command
struct Bubo: ParsableCommand {
    static let configuration = CommandConfiguration(
    abstract: "Bubo is a tool to aid developers with the decomposiotion of systems into microservices.",
    subcommands: [New.self])
    
    // Display bubo version with --version
    @Flag(help: "Display current Verison of Bubo")
    var version: Bool
    
    func run() throws {
        let fileManagement: FileManagment = FileManagment()
        if version {
            print("Version: \(versionNumber)")
        } else {
            print("Please refer to Bubo -h for more information")
        }
    }
}

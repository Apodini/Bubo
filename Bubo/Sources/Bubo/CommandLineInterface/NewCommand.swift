//
//  File.swift
//  
//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import ShellOut
import Foundation



// Command to create a new bubo repository
extension Bubo {
    struct New: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Create a new Bubo Project.")
        
        @Argument(help: "The name of the new bubo project")
        var projectName: String
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("'<name>' is to long")
            }
        }
        
        func run() {
            let fileManagement = FileManagment()
            
            if fileManagement.checkInit() { // Check if the root repo has been initialised
                fileManagement.initNewRepo(name: projectName) // Init new anchor repo
            } else {
                fileManagement.initBubo() // Init root repo
                fileManagement.initNewRepo(name: projectName) // Init new anchor repo
            }
        }
    }
}

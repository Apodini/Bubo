//
//  File.swift
//  
//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser

extension Bubo {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all Bubo projects")
        
        func run() {
            guard let projects = rootConfig.projects else {
                errorMessage(msg: "Can't list prrojeects because Bubo ha not been initialised")
                return
            }
            
            for (projectName, projectURL) in projects {
                let name = projectName.blue().underline()
                let url = projectURL.path.yellow()
                print("\(name) -> \(url)")
            }
        }
    }
}

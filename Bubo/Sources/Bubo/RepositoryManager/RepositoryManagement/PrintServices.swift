//
//  File.swift
//  
//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension RepositoryManagement {
    func printServices(projectName: String) -> Void {
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't list prrojects because Bubo ha not been initialised.")
            return
        }
        if projects.isEmpty {
            print("No projects have been created. Use the Bubo new command to create an repository")
        } else {
            let fileManagement = FileManagment()
            guard let projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
                errorMessage(msg: "Can't update services of \(projectName) because it's not possible to decode the projects runtime configuration")
                return
            }
            let colorProjektName = projectName.blue()
            headerMessage(msg: "Services in project \(colorProjektName)")
            let services = projectConfig.repositories
            for service in services {
                let name = service.name .blue().underline()
                let url = service.gitURL.absoluteString.yellow()
                print("\(name) -> \(url)")
            }
        }
    }
}

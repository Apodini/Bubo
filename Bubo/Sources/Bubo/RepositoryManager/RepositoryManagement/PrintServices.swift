//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension RepositoryManagement {
    func printServices(projectName: String) -> Void {
        let colorProjektName = projectName.blue()
        headerMessage(msg: "Services in project \(colorProjektName)")
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't list services of \(projectName) because no projects exists in root configuration")
            return
        }
        if projects.isEmpty {
            errorMessage("No projects have been created. Use the Bubo new command to create an repository.")
            return
        } else {
            let fileManagement = FileManagment()
            guard let projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
                abortMessage(msg: "List services for \(projectName)")
                return
            }
            let services = projectConfig.repositories
            if services.isEmpty {
                warningMessage(msg: "No services have been added to \(projectName). Add new services to the project with the add command.")
                return
            }
            for (_, service) in services {
                let name = service.name .blue().underline()
                let url = service.gitURL.absoluteString.yellow()
                print("\(name) -> \(url)")
            }
        }
    }
}

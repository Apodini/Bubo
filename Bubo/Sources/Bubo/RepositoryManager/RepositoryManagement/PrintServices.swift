//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension RepositoryManagement {
    func printServices(projectName: String?) -> Void {
        guard let (projectHandle,_) = fileManagement.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        let colorProjektName = projectHandle.blue()
        headerMessage(msg: "Services in project \(colorProjektName)")
        guard let projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
            abortMessage(msg: "List services for \(projectHandle)")
            return
        }
        let services = projectConfig.repositories
        if services.isEmpty {
            warningMessage(msg: "No services have been added to \(projectHandle). Add new services to the project with the add command.")
            return
        }
        for (_, service) in services {
            let name = service.name .blue().underline()
            let url = service.gitURL.absoluteString.yellow()
            print("\(name) -> \(url)")
        }
    }
}

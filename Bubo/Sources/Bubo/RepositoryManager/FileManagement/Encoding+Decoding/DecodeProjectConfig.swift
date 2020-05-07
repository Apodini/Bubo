//
//  File.swift
//  
//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation


extension FileManagement {
    func decodeProjectConfig(projectName: String?) -> Optional<Anchorrc> {
        guard let (projectHandle, projects) = self.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return nil
        }
        guard let configURL = projects[projectHandle]?.appendingPathComponent("anchorrc").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get projects configuration file path. Does the project exist?")
            return nil
        }
        let fileURL = URL(fileURLWithPath: configURL.path)
        return decodeProjectConfigfromJSON(url: fileURL)
    }
}

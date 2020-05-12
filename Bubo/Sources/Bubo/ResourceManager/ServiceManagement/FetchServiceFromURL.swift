//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut

extension ResourceManager {
    func fetchServiceFromURL(serviceURL: URL) -> Service? {
        let fileManager = FileManager.default
        let name = fileManager.displayName(atPath: serviceURL.path)
    
        do {
            let gitURLstring = try shellOut(to: "git -C \(serviceURL.path) config --get remote.origin.url")
            guard let gitURL = URL(string: gitURLstring) else {
                errorMessage(msg: "Can't parse the git remote URL \(gitURLstring) for service \(serviceURL.path) into the URL format")
                abortMessage(msg: "Service creation")
                return nil
            }
            return Service(name: name, url: serviceURL, gitURL: gitURL)
        } catch {
            errorMessage(msg: "Can't read the git remote URL for \(serviceURL.path)")
            abortMessage(msg: "Service creation")
            return nil
        }
    }
}

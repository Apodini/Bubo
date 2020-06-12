//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut

extension ResourceManager {
    func fetchServiceFromURL(serviceURL: URL) -> Service? {
        let fileManager = FileManager.default
        let name = fileManager.displayName(atPath: serviceURL.path)
        var gitHash = ""
        var gitURL: URL? = nil
        var gitRootURL: URL? = nil
        
        let files: [File] = fileCrawler(startURL: serviceURL)
        
        for file in files {
            if file.fileName == "Package.swift" {
                gitRootURL = file.fileURL.deletingPathExtension().deletingLastPathComponent()
            }
        }
        
        guard let gitRootURLresolved = gitRootURL else {
            outputMessage(msg: "Can't resolve git root directory for URL \(serviceURL.path)")
            return nil
        }
    
        do {
            let gitURLstring = try shellOut(to: "git -C \(gitRootURLresolved.path) config --get remote.origin.url")
            gitURL = URL(string: gitURLstring)
        } catch {
            errorMessage(msg: "Can't read the git remote URL for \(gitRootURLresolved.path)")
            abortMessage(msg: "Service creation")
            return nil
        }
        
        do {
            gitHash = try shellOut(to: "git -C \(gitRootURLresolved.path) rev-parse HEAD")
        } catch {
            errorMessage(msg: "Can't read the git hash for \(gitRootURLresolved.path)")
            abortMessage(msg: "Service creation")
            return nil
        }
        
        guard let gitURLresolved = gitURL else {
            errorMessage(msg:
                "Can't parse the git remote URL" +
                " for service \(serviceURL.path)" +
                " into the URL format")
            abortMessage(msg: "Service creation")
            return nil
        }
        
        return Service(name: name, url: serviceURL, gitURL: gitURLresolved, currentGitHash: gitHash, currentBuildGitHash: nil, files: files)
    }
}

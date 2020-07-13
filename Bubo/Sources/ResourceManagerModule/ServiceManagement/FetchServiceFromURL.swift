//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut


extension ResourceManager {
    
    /// Validates if there is a service at the passed URL and creates a new service configuration data object.
    ///
    /// - parameter serviceURL: The URL where the service is located.
    /// - returns: A service configuration data object if the service exists, else nil.
    
    public func fetchServiceFromURL(serviceURL: URL) -> ServiceConfiguration? {
        
        let fileManager = FileManager.default
        
        /// Create the service name out of the directory name
        let name = fileManager.displayName(atPath: serviceURL.path)
        var gitHash = ""
        var gitURL: URL? = nil
        var gitRootURL: URL? = nil
        
        /// Run the file crawler over the filesystems subtree starting at `serviceURL` to get all relevant files of the service
        let files: [File] = fileCrawler(startURL: serviceURL)
        
        /// Check if the service has a package.swift and assume that the git root directory is located here.
        /// - TODO: Rework this part, so that it actually searches for a .git directory
        for file in files {
            if file.fileName == "Package.swift" {
                gitRootURL = file.fileURL.deletingPathExtension().deletingLastPathComponent()
            }
        }
        
        guard let gitRootURLresolved = gitRootURL else {
            outputMessage(msg: "Can't resolve git root directory for URL \(serviceURL.path)")
            return nil
        }
    
        /// Fetch the git remote origin URL to determine where the service was originally clonded from
        do {
            let gitURLstring = try shellOut(to: "git -C \(gitRootURLresolved.path) config --get remote.origin.url")
            gitURL = URL(string: gitURLstring)
        } catch {
            errorMessage(msg: "Can't read the git remote URL for \(gitRootURLresolved.path)")
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
        
        /// Fetch the hash of the last commit to validate it against the last build and rebuild if necessary
        do {
            gitHash = try shellOut(to: "git -C \(gitRootURLresolved.path) rev-parse HEAD")
        } catch {
            errorMessage(msg: "Can't read the git hash for \(gitRootURLresolved.path)")
            abortMessage(msg: "Service creation")
            return nil
        }
        
        /// Return a new service configuration object
        return ServiceConfiguration(name: name, url: serviceURL, gitURL: gitURLresolved, currentGitHash: gitHash, files: files)
    }
}

//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

extension ResourceManager {
    
    /// An recursive file system crawler that finds all files that are in a not hidden directory in a filesystem subtree
    ///
    /// - parameter startURL: The URL of a directory where the crawler starts crawling the file tree
    /// - returns: An array of file objects that identify a file
    
    public func fileCrawler(startURL: URL) -> [File] {
        var files: [File] = []
        
        do {
            
            /// Try to get the contents of the passed directory
            let serviceContents = try fileManager.contentsOfDirectory(at: startURL, includingPropertiesForKeys: nil)
            
            /// Iterate over all directory contents, check if they are files or directories and start a new crawler for each directory
            for url in serviceContents {
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
                    if isDir.boolValue {
                        /// check if the directory is hidden
                        if url.lastPathComponent.first != "." {
                            files.append(contentsOf: fileCrawler(startURL: url))
                        } else {
                            outputMessage(msg: "Crawler: Skipping directory \(url.path)")
                        }
                    } else {
                        files.append(File(url: url, name: url.lastPathComponent))
                    }
                }
            }
        } catch {
            errorMessage(msg: "Can't read contents of directory at path: \(startURL)")
            return []
        }
        return files
    }
}

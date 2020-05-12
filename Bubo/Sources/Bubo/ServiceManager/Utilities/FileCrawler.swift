//
//  File.swift
//  
//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

extension ServiceManager {
    func fileCrawler(startURL: URL) -> [File] {
        var sourceFiles: [File] = []
        do {
            let serviceContents = try fileManager.contentsOfDirectory(at: startURL, includingPropertiesForKeys: nil)
            for url in serviceContents {
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
                    if isDir.boolValue {
                        sourceFiles.append(contentsOf: fileCrawler(startURL: url))
                    } else {
                        if url.pathExtension == "swift" {
                            sourceFiles.append(File(url: url))
                        }
                    }
                }
            }
        } catch {
            errorMessage(msg: "Can't read contents of directory at path: \(startURL)")
            return []
        }
        return sourceFiles
    }
}

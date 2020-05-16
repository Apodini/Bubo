//
//  File.swift
//  
//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

extension ResourceManager {
    func fileCrawler(startURL: URL) -> [File] {
        var files: [File] = []
        do {
            let serviceContents = try fileManager.contentsOfDirectory(at: startURL, includingPropertiesForKeys: nil)
            for url in serviceContents {
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
                    if isDir.boolValue {
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

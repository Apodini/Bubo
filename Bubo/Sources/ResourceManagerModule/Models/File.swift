//
//  File.swift
//  Bubo
//
//  Created by Valentin Hartig on 12/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation

// MARK: File: Codable
/// A basic representation of a file that is encodable as JSON
public struct File: Codable {
    public let fileURL: URL
    public let fileName: String

    public init(url: URL, name: String) {
        self.fileURL = url
        self.fileName = name
    }
}

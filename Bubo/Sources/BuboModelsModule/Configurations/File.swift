//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

/// A basic representation of a file that is encodable as JSON

public struct File: Codable {
    public let fileURL: URL
    public let fileName: String

    public init(url: URL, name: String) {
        self.fileURL = url
        self.fileName = name
    }
}

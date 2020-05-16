//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
//import SwiftSyntax

struct File: Codable {
    let fileURL: URL
    let fileName: String

    init(url: URL, name: String) {
        self.fileURL = url
        self.fileName = name
    }
}

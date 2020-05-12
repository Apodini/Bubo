//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
//import SwiftSyntax

struct File: Codable {
    let fileURL: URL

    init(url: URL) {
        self.fileURL = url
    }
}

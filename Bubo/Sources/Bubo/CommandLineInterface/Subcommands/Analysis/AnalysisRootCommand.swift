//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ArgumentParser

extension Bubo {
    struct Analysis: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "All analysises performed on service or project",
            subcommands: [
                Crawl.self
        ])
    }
}

//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ArgumentParser


extension Bubo.Service {
    
    /// **Subcommand**: The root for all analysis subcommands that can be run on a project or service
    struct Analyse: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "All analyses performed on a service or project",
            subcommands: [
                Crawl.self,
                Graph.self,
                Dot.self
        ])
    }
}

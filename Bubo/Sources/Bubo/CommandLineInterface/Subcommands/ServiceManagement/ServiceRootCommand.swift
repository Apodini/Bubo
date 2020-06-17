//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation
import ArgumentParser


extension Bubo {
    
    /// **Subcommand**: Root for all service based subcommands
    struct Service: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "All actions performed on services of a specific project",
            subcommands: [
                Add.self,
                List.self,
                Pull.self,
                Refresh.self,
                Remove.self
        ])
    }
}

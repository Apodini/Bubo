//
//  AnalysisRootCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 12/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ArgumentParser

// MARK: - Analyse
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

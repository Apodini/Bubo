//
//  IndexDatabaseConfiguration.swift
//  Bubo
//
//  Created by Valentin Hartig on 20/06/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation

// MARK: IndexDatabaseConfiguration
/// Represents a configuration for the indexing database
struct IndexDatabaseConfiguration {
    
    /// The path to the raw index store data, if any.
    var indexStorePath: String?
    
    /// The path to put the index database, if any.
    var indexDatabasePath: String?
    
    /// The standard constructor. If no index database path is passed it creates a temporary directory for it (This is the standard case) 
    init(indexStorePath: URL?, indexDatabasePath: String?) {
        self.indexStorePath = indexStorePath?.path
        
        if indexDatabasePath == nil {
            self.indexDatabasePath = NSTemporaryDirectory() + "index_\(getpid())";
        } else  {
            self.indexDatabasePath = indexDatabasePath
        }
    }
}

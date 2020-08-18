//
//  GetMostRecentGraphSnapshot.swift
//  Bubo
//
//  Created by Valentin Hartig on 07/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation


// MARK: ResourceManager
extension ResourceManager {
    
    /// Fetches the most recent graphsnapshot for a given service configuration
    
    public func getMostRecentGraphSnapshot(service: ServiceConfiguration) -> GraphSnapshot? {
        
        var snaps = service.graphSnapshots
        
        guard let snapshotUrl = snaps.popLast() else {
            outputMessage(msg: "No previous graph snapshot available")
            return nil
        }
        
        guard let snapshot: GraphSnapshot = decodeGraphSnapshotfromJSON(url: snapshotUrl) else {
            abortMessage(msg: "Get most recent graph snapshot")
            return nil
        }
        
        return snapshot
    }
}

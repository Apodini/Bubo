//
//  SymbolHashToken.swift
//  Bubo
//
//  Created by Valentin Hartig on 20/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import IndexStoreDB


// MARK: GraphBuilder
extension GraphBuilder {
    
    // MARK: SymbolHashToken
    /// A simple hash token to represent a Symbol in a set
    public struct SymbolHashToken: Hashable {
        var usr: String
        var kind: IndexSymbolKind
        
        init(usr: String, kind: IndexSymbolKind) {
            self.usr = usr
            self.kind = kind
        }
    }
}

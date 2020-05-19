//
//  File.swift
//  
//
//  Created by Valentin Hartig on 17.05.20.
//

import Foundation

class Node: Codable, Equatable {
    var name: String
    init() {
        self.name = "hello world!"
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return false
    }
}

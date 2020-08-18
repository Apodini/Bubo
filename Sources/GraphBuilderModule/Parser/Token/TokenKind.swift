//
//  TokenKind.swift
//  Bubo
//
//  Created by Valentin Hartig on 27/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation


// MARK: TokenKind
/// Enmu that represents a subset of all possible node kinds 
public enum TokenKind {
    case `class`
    case `struct`
    case function
    case `enum`
    case `protocol`
    case `typealias`
    case `operator`
    case `extension`
}

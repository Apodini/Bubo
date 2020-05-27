//
//  File.swift
//  
//
//  Created by Valentin Hartig on 27.05.20.
//

import Foundation

public struct TokenRelation: Equatable {
  public var token: Token
  public var relation: TokenRole

  public init(token: Token, relation: TokenRole) {
    self.token = token
    self.relation = relation
  }
}

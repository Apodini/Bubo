//
//  RootCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 21/04/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import ArgumentParser
import Foundation
import OperationsManagerModule


// MARK: - Main
/// This class kicks off all operations in Bubo and initialises the command line interface 
class Main {
    public static let operationsManager: OperationsManager = OperationsManager()

    init() {
        /// kick off program execution
        Bubo.main()
    }
}

let main = Main()

//
//  File.swift
//  
//
//  Created by Valentin Hartig on 25.04.20.
//

import Foundation
import ColorizeSwift

public func errorMessage(msg: String) -> Void {
    print("ERROR: \(msg)".red())
}

public func warningMessage(msg: String) -> Void {
    print("WARNING: \(msg)" .yellow())
}

public func successMessage(msg: String) -> Void {
    print("✓ \(msg)" .green())
}

public func headerMessage(msg: String) -> Void {
    print(msg .bold())
}

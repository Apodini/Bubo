//
//  Created by Valentin Hartig on 25.04.20.
//

import Foundation
import ColorizeSwift


/// Output an error message on stdout.
///
/// - parameter msg: The message to output.

public func errorMessage(msg: String) -> Void {
    print("ERROR: \(msg)" .red())
}


/// Output a warning message on stdout.
///
/// - parameter msg: The message to output.

public func warningMessage(msg: String) -> Void {
    print("WARNING: \(msg)" .yellow())
}


/// Output a success message on stdout.
///
/// - parameter msg: The message to output.

public func successMessage(msg: String) -> Void {
        print("✓ \(msg)" .green())
}


/// Output a header message on stdout that seperates different main operations.
///
/// - parameter msg: The message to output.

public func headerMessage(msg: String) -> Void {
    print(msg .bold())
}


/// Output a standard output message on stdout. These are only displayed if the verbose mode is activated.
///
/// - parameter msg: The message to output.

public func outputMessage(msg: String) -> Void {
    if rootConfig.verboseMode {
        print(msg .dim())
    }
}


/// Output an abort message on stdout when an operation is aborted due to an error
///
/// - parameter msg: The message to output

public func abortMessage(msg: String) -> Void {
    print("ABORT: \(msg)" .red())
}

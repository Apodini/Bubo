import ArgumentParser
import Foundation
import OperationsManagerModule

class Main {
    public static let operationsManager: OperationsManager = OperationsManager()

    init() {
        /// kick off program execution
        Bubo.main()
    }
}

let main = Main()

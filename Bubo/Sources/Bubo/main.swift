import ArgumentParser
import Foundation
import ResourceManagerModule

class Main {
    
    public static let resourceManager = ResourceManager()
    
    init() {
        /// kick off program execution
        Bubo.main()
    }
}

let main = Main()

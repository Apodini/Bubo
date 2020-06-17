import ArgumentParser
import Foundation

public var initStatus: Bool = false
public var rootConfig: Buborc = Buborc(
    version: "0.0.1",
    projects: [:]
)


class Main {
    
    init() {
        let resourceManager = ResourceManager()
        
        /// Check if the program has been initalised
        initStatus = resourceManager.checkInit()
        if !initStatus {
            
            /// if not present: initialise Bubo
            resourceManager.initRoot(configData: rootConfig)
            initStatus = resourceManager.checkInit()
        } else {
            
            /// else decode the root configuration
            resourceManager.decodeRootConfig()
        }
        
        /// kick off program execution
        Bubo.main()
    }
}

let main = Main()

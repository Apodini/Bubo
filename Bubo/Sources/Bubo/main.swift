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
        // Check if a root config fo the current directory is present
        initStatus = resourceManager.checkInit()
        if !initStatus {
            // not present: initialise Bubo
            resourceManager.initRoot(configFile: rootConfig)
            initStatus = resourceManager.checkInit()
        } else {
            resourceManager.decodeRootConfig()
        }
        Bubo.main()
    }
}

let main = Main()

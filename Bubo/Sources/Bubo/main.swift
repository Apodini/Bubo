import ArgumentParser
import Foundation

public var initStatus: Bool = false
public var rootConfig: Buborc = Buborc(
    version: "0.0.1",
    projects: [:]
)


class Main {
    
    init() {
        let fileManagement = FileManagement()
        // Check if a root config fo the current directory is present
        initStatus = fileManagement.checkInit()
        if !initStatus {
            // not present: initialise Bubo
            fileManagement.initRoot(configFile: rootConfig)
            initStatus = fileManagement.checkInit()
        } else {
            fileManagement.decodeRootConfig()
        }
        Bubo.main()
    }
}

let main = Main()

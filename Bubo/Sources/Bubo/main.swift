import ArgumentParser
import Foundation

public var initStatus: Bool = false
public var globalVerbose: Bool = false
public var versionNumber = "0.0.1"
public var rootConfig: Buborc = Buborc(
    version: versionNumber,
    projects: [:]
)


class Main {
    
    init() {
        let fileManagement = FileManagment()
        // Check if a root config fo the current directory is present
        initStatus = fileManagement.checkInit()
        if !initStatus {
            // not present: initialise Bubo
            initStatus = fileManagement.initBubo(configFile: rootConfig)
        } else {
            fileManagement.decodeRootConfig()
        }
        Bubo.main()
    }
}

let main = Main()

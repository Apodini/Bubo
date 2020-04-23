import ArgumentParser
import Foundation

public var versionNumber = "0.0.1"
public var rootConfig: Buborc = Buborc(
    version: versionNumber,
    projects: []
)

class Main {
    public var initStatus: Bool
    
    init() {
        
        let fileManagement = FileManagment()
        self.initStatus = fileManagement.checkInit()
        NSLog("InitStatus: \(self.initStatus)")
        if !self.initStatus {
            self.initStatus = fileManagement.initBubo(configFile: rootConfig)
        } else {
            fileManagement.decodeRootConfig()
        }
        Bubo.main()
    }
}

Main()

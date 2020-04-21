import ArgumentParser
import ShellOut
import Foundation

public var versionNumber = "0.0.1"
public var rootConfig: Buborc

class Main {
    public var initStatus: Bool
    
    init() {
        let fileManagement = FileManagment()
        self.initStatus = fileManagement.checkInit()
        if !self.initStatus {
            self.initStatus = fileManagement.initBubo()
        }
        fileManagement.decodeRootConfig()
        versionNumber = rootConfig.version
        Bubo.main()
    }
}

Main()

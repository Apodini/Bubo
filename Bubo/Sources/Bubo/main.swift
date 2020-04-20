import ArgumentParser
import ShellOut
import Foundation

struct Bubo: ParsableCommand {
    static let configuration = CommandConfiguration(
    abstract: "Bubo is a tool to aid developers with the decomposiotion of systems into microservices.",
    subcommands: [New.self])
    
    @Flag(help: "Display current Verison of Bubo")
    var version: Bool
    
    func run() throws {
        let fileManagement: FileManagment = FileManagment()
        if version {
            print("Version: 0.0.1")
        } else {
            print("Please refer to Bubo -h for more information")
        }
        
        if !fileManagement.checkInit() {
            fileManagement.initBubo()
        }
        
    }
}

extension Bubo {
    struct New: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Create a new Bubo Project.")
        
        @Argument(help: "The highest value to pick.")
        var name: String
        
        func validate() throws {
            guard name.count <= 255 else {
                throw ValidationError("'<name>' is to long")
            }
        }
        
        func run() {
            
            let fileManagement: FileManagment = FileManagment()
            if fileManagement.checkInit() {
                fileManagement.initNewRepo(name: name)
            } else {
                fileManagement.initBubo()
                fileManagement.initNewRepo(name: name)
            }
            
        }
    }
    
}

Bubo.main()

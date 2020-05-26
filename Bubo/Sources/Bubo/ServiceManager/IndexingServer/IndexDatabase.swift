import Foundation
import IndexStoreDB

class IndexDatabase {
    
    static let libIndexStore = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libIndexStore.dylib"
        
    let indexDBConfig: IndexDatabaseConfiguration

    /// The source code index, if available.
    var index: IndexStoreDB? = nil
    
    /// The directory containing the original, unmodified project.
    init(indexDBConfig: IndexDatabaseConfiguration) throws {
        self.indexDBConfig = indexDBConfig
        
        if let storePath = indexDBConfig.indexStorePath,
            let dbPath = indexDBConfig.indexDatabasePath {
            do {
                let lib = try IndexStoreLibrary(dylibPath: IndexDatabase.libIndexStore)
                self.index = try IndexStoreDB(
                    storePath: URL(fileURLWithPath: storePath).path,
                    databasePath: URL(fileURLWithPath: dbPath).path,
                    library: lib,
                    listenToUnitEvents: false)
                outputMessage(msg: "opened IndexStoreDB at \(dbPath) with store path \(storePath)")
            } catch {
                errorMessage(msg: "failed to open IndexStoreDB: \(error.localizedDescription)")
            }
        }
    }
}

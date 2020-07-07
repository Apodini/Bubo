import Foundation
import IndexStoreDB
import BuboModelsModule
import OutputStylingModule


/// Represents an IndexingDatabase instance
public class IndexDatabase {
    
    /// The path to the XCode default toolchain that contains the indexStore library needed to create a database
    static let libIndexStore = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libIndexStore.dylib"
        
    /// The indexStore configuration that contains the database and the store pat
    let indexDBConfig: IndexDatabaseConfiguration

    /// The source code index, if available.
    var index: IndexStoreDB? = nil
    
    /// A Constructor that creates the index if possible
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
                outputMessage(msg: "Opened IndexStoreDB at \(dbPath) with store path \(storePath)")
            } catch {
                errorMessage(msg: "Failed to open IndexStoreDB: \(error.localizedDescription)")
            }
        }
    }
}

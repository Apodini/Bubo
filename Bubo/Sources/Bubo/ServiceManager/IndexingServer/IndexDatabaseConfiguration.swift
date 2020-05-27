import Foundation

struct IndexDatabaseConfiguration {
    
    // The path to the raw index store data, if any.
    var indexStorePath: String?
    
    // The path to put the index database, if any.
    var indexDatabasePath: String?
    
    init(indexStorePath: URL?, indexDatabasePath: String?) {
        self.indexStorePath = indexStorePath?.path
        
        if indexDatabasePath == nil {
            self.indexDatabasePath = NSTemporaryDirectory() + "index_\(getpid())";
        } else  {
            self.indexDatabasePath = indexDatabasePath
        }
    }
}

import Foundation


/// Represents a configuration for the indexing database
struct IndexDatabaseConfiguration {
    
    /// The path to the raw index store data, if any.
    var indexStorePath: String?
    
    /// The path to put the index database, if any.
    var indexDatabasePath: String?
    
    /// The standard constructor. If no index database path is passed it creates a temporary directory for it (This is the standard case) 
    init(indexStorePath: URL?, indexDatabasePath: String?) {
        self.indexStorePath = indexStorePath?.path
        
        if indexDatabasePath == nil {
            self.indexDatabasePath = NSTemporaryDirectory() + "index_\(getpid())";
        } else  {
            self.indexDatabasePath = indexDatabasePath
        }
    }
}

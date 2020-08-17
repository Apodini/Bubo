import Foundation
import IndexStoreDB


/// The indexingserver object provides an endpoint to query an indexing database
public class IndexingServer {
    
    /// The indexing databse that is queried
    let indexDatabase: IndexDatabase?
    
    /// The standard constructor
    public init(indexDatabase: IndexDatabase? = nil) {
        self.indexDatabase = indexDatabase
    }
    
    
    /// Finds all symbol occurences for a specific symbol name in the indexing database
    ///
    /// - parameter matching: The name of the symbol that is searched for
    /// - returns: An array of indexStoreDB `SymbolOccurence`s
    
    func findSymbolsMatchingName(matching: String) -> [SymbolOccurrence] {
        var symbolOccurrenceResults: [SymbolOccurrence] = []
        indexDatabase?.index?.forEachCanonicalSymbolOccurrence(
          containing: matching,
          anchorStart: true,
          anchorEnd: true,
          subsequence: true,
          ignoreCase: true
        ) { symbol in
            if !symbol.location.isSystem {
            symbolOccurrenceResults.append(symbol)
          }
          return true
        }
        return symbolOccurrenceResults
    }
    
    /// Finds all symbols that are related to a specific symbol
    ///
    /// - parameters:
    ///     - usr: The Unified Symbol Resolution for the symbol that you want to query
    ///     - roles: A specific symbol role that idenfies the relationship
    /// - returns: An array of indexStoreDB `SymbolOccurence`s that represents all symbols related to the usr with the role
    /// - note: I'm not 100% sure that im using this API in the right way. There is no documentation for it so use with caution
    func findRelatedSymbols(relatedToUSR usr: String, roles: SymbolRole) -> [SymbolOccurrence] {
        guard let index = self.indexDatabase?.index else {
            return []
        }
        return index.occurrences(relatedToUSR: usr, roles: roles)
    }
    
    /// Finds all symbols for the provided USR
    ///
    /// - parameters:
    ///     - usr: The Unified Symbol Resolution for the symbol that you want to query
    ///     - role: The role of the symbol 
    /// - returns: An array of indexStoreDB `SymbolOccurence`s that represents all symbols with the usr
    /// - note: I'm not 100% sure that im using this API in the right way. There is no documentation for it so use with caution
    func occurrences(ofUSR usr: String, roles: SymbolRole) -> [SymbolOccurrence] {
        guard let index = self.indexDatabase?.index else {
            return []
        }
        return index.occurrences(ofUSR: usr, roles: roles)
    }
}

import Foundation
import IndexStoreDB

class IndexingServer {
    
    let indexDatabase: IndexDatabase?
    
    init(indexDatabase: IndexDatabase? = nil) {
        self.indexDatabase = indexDatabase
    }
    
    func findWorkspaceSymbols(matching: String) -> [SymbolOccurrence] {
        var symbolOccurrenceResults: [SymbolOccurrence] = []
        indexDatabase?.index?.forEachCanonicalSymbolOccurrence(
          containing: matching,
          anchorStart: true,
          anchorEnd: true,
          subsequence: true,
          ignoreCase: true
        ) { symbol in
            if !symbol.location.isSystem &&
                !symbol.roles.contains(.accessorOf) &&
                symbol.roles.contains(.definition) {
            symbolOccurrenceResults.append(symbol)
          }
          return true
        }
        return symbolOccurrenceResults
    }
    
    func occurrences(ofUSR usr: String, roles: SymbolRole, workspace: IndexDatabase) -> [SymbolOccurrence] {
        guard let index = workspace.index else {
            return []
        }
        return index.occurrences(ofUSR: usr, roles: roles)
    }
}

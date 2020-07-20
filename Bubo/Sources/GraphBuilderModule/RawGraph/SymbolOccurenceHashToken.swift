//
//  Created by Valentin Hartig on 20.07.20.
//

import Foundation
import IndexStoreDB

extension GraphBuilder {
    public struct SymbolOccurenceHashToken: Hashable {
         var usr: String
         var kind: IndexSymbolKind
         var roles: SymbolRole
         var path: String
         var isSystem: Bool
         var line: Int
         var utf8Column: Int
         
         init(usr: String, kind: IndexSymbolKind, roles: SymbolRole, path: String, isSystem: Bool, line: Int, utf8Column: Int) {
             self.usr = usr
             self.kind = kind
             self.roles = roles
             self.path = path
             self.isSystem = isSystem
             self.line = line
             self.utf8Column = utf8Column
         }
     }
}

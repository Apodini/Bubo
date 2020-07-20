//
//  Created by Valentin Hartig on 20.07.20.
//

import Foundation
import IndexStoreDB

extension GraphBuilder {
    public struct SymbolHashToken: Hashable {
        var usr: String
        var kind: IndexSymbolKind
        
        init(usr: String, kind: IndexSymbolKind) {
            self.usr = usr
            self.kind = kind
        }
    }
}

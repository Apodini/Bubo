//
//  Created by Valentin Hartig on 27.05.20.
//

import Foundation


public enum TokenRole {
    // MARK: Primary roles, from indexstore
    case `declaration`
    case `definition`
    case `reference`
    case `read`
    case `write`
    case `call`
    case `dynamic`
    case `addressOf`
    case `implicit`

    // MARK: Relation roles, from indexstore
    case `childOf`
    case `baseOf`
    case `overrideOf`
    case `receivedBy`
    case `calledBy`
    case `extendedBy`
    case `accessorOf`
    case `containedBy`
    case `ibTypeOf`
    case `specializationOf`
}

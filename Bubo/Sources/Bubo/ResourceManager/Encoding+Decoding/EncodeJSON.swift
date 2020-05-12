//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    func encodeDataToJSON(config: Buborc) -> Optional<Data> {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode root configuration file")
            return nil
        }
    }
    
    func encodeDataToJSON(config: Anchorrc) -> Optional<Data> {
        let encoder = JSONEncoder()
        do {
            let data: Data = try encoder.encode(config)
            return data
        } catch {
            errorMessage(msg: "Encoder couldn't encode project configuration file")
            return nil
        }
    }
}

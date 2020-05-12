//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    func decodeDatafromJSON(url: URL) -> Optional<Buborc> {
        let decoder = JSONDecoder()
        var config: Buborc?
        do {
            try config = decoder.decode(Buborc.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Decoder couldn't decode root configuration file at path \(url.path)")
            return nil
        }
        return config
    }
    
    func decodeProjectConfigfromJSON(url: URL) -> Optional<Anchorrc> {
        let decoder = JSONDecoder()
        var config: Anchorrc?
        do {
            try config = decoder.decode(Anchorrc.self, from: Data(contentsOf: url))
        } catch {
            errorMessage(msg: "Decoder couldn't decode project configuration file at path \(url.path)")
            return nil
        }
        return config
    }
}

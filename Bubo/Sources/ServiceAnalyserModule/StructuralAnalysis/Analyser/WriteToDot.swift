//
//  Created by Valentin Hartig on 13.07.20.
//

import Foundation
import GraphBuilderModule
import ResourceManagerModule

extension StructuralAnalyser {
    public func writeToDot() -> Void {
         outputMessage(msg: "Writing graph to .dot output file and saving it in project directory")
         
         guard let (_, projectConfig) = self.resourceManager.decodeProjectConfig(pName: projectName) else {
             errorMessage(msg: "Couldn't write graph to .dot file because the project confidguration cannot be decoded!")
             return
         }
         
         var url: URL = URL(fileURLWithPath: projectConfig.url
             .appendingPathComponent("output").path)
         
         let fileManager = FileManager.default
         
         if !fileManager.fileExists(atPath: url.path) {
             do {
                 try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
                 
             } catch {
                 errorMessage(msg: "Couldn't create output directory")
                 return
             }
         }
         
         url = url
             .appendingPathComponent(service.name)
             .appendingPathExtension("dot")
         
         fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
         
         do {
             try mostRecentGraphSnapshot!.graph.description.write(to: url, atomically: false, encoding: .utf8)
             successMessage(msg: "Graph output is at \(url.path)")
         } catch {
             warningMessage(msg: "Couldn't write graph to dot file")
             print("ERROR INFO: \(error)")
         }
     }
}

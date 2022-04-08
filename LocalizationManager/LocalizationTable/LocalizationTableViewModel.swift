//
//  LocalizationTableViewModel.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import Foundation
import SwiftUI


struct val: Codable, Hashable{
    var local: String
    var values: [String: String]
}

class LocalizationTableViewModel: ObservableObject{
    let path: String
    @Published var localizations: [String] = []
    @Published var values: [val] = []
    @Published var newKey = ""
    @Published var searchKey = ""
    init(_ pathURL: String){
        self.path = pathURL
        getLocalizations()
        for loc in localizations{
            getItems(loc)
        }
    }
    private func getItems(_ localization: String){
        let folderPath = "\(path)/\(localization)"
        let fileNames = try! FileManager.default.contentsOfDirectory(atPath: folderPath)
        for fileName in fileNames where fileName.contains(".string") {
            print("going through \(fileName)")
            var dict: [String:String] = [:]
            do {
                let lines = try String(contentsOfFile: "\(folderPath)/\(fileName)").components(separatedBy: "\n").filter({$0.contains("=") && !$0.contains("/")})
                for line in lines{
                    let doubleLine = line.components(separatedBy: " = ")
                    if let first = doubleLine.first?.replacingOccurrences(of: "\"", with: ""),
                       let last = doubleLine.last?.replacingOccurrences(of: "\"", with: ""){
                        dict[first] = last.replacingOccurrences(of: ";", with: "")
                    }
                    
                }
                values.append(val(local: localization, values: dict))
            }
            catch {/* error handling here */}
        }
        
    }
    
    func getLocalizations(){
        let fileNames = try! FileManager.default.contentsOfDirectory(atPath: path)
        localizations.removeAll()
        for fileName in fileNames where fileName.contains(".lproj") {
            localizations.append(fileName)
        }
        
    }
    
    func saveFiles(){
        for value in values {
            let filePath = "\(path)/\(value.local)/Localizable.strings"
            //writing
            do {
                var text = ""
                for (key, tex) in value.values{
                    let line = "\"\(key)\" = \"\(tex)\";\n"
                    text.append(line)
                }
                try text.write(toFile: filePath, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
        
    }
    
    func add(){
        withAnimation {
            for ind in 0..<values.count{
                if values[ind].values[newKey] == nil || newKey != ""{
                    values[ind].values[newKey] = newKey
                }else{
                    return
                }
            }
        }
        saveFiles()
    }
    
    func remove(_ key: String){
        withAnimation {
            for ind in 0..<values.count{
                values[ind].values.removeValue(forKey: key)
            }
        }
        
        saveFiles()
    }
    
}

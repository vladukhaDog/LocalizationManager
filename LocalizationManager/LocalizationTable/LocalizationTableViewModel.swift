//
//  LocalizationTableViewModel.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import Foundation
import SwiftUI


struct val: Codable, Hashable{
    var readableLocal: String{
        local.replacingOccurrences(of: ".lproj", with: "")
    }
    var local: String
    var values: [String: String]
    subscript(key: String) -> String {
        get {
            return self.values[key] ?? "NO TRANSLATION"
            // Return an appropriate subscript value here.
        }
        set(newValue) {
            self.values[key] = newValue
            // Perform a suitable setting action here.
        }
    }
}

class LocalizationTableViewModel: ObservableObject{
    let path: String
    @Published var localizations: [String] = []
    @Published var values: [val] = []
    @Published var newKey = ""
    @Published var searchKey = ""
    init(_ pathURL: String){
        if pathURL == "test"{
            self.localizations = ["en", "ru"]
            self.path = pathURL
            self.values = [val(local: "en", values: ["kek": "kekk"])]
        }else{
            self.path = pathURL
            getLocalizations()
            for loc in localizations{
                getItems(loc)
            }
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
    func commit(){
        func safeShell(_ command: String) throws -> String {
            let task = Process()
            let pipe = Pipe()
            
            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = ["-c", command]
            task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated

            try task.run() //<--updated
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            
            return output
        }

        // Example usage:
        do {
            var command = "cd \(path); "
            for value in values {
                let filePath = "git add \(path)/\(value.local)/Localizable.strings; "
                command += filePath
            }
            command += "git commit -m \"new localizable files, commited through LocalizationManager by Vladislav Permyakov\"; git push;"
            print(command)
            print(try safeShell(command))
        }
        catch {
            print("\(error)") //handle or silence the error here
        }
    }
    
    func add(){
        withAnimation {
            for ind in 0..<values.count{
                if values[ind].values[newKey] == nil || newKey != ""{
                    values[ind][newKey] = newKey
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

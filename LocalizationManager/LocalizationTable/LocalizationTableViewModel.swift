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
    
    @Published var isGitRepository = false
    @Published var loadingGitFunctionality = false
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
        checkIfGitRepository()
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
    
    private func safeShell(_ command: String) throws -> String {
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
    
    func checkIfGitRepository(){
        DispatchQueue.global(qos: .userInitiated).async{
            do {
                var command = "cd \(self.path); "
                command += "git rev-parse --is-inside-work-tree;"
                
                let output = try self.safeShell(command)
                
                if output.contains("true"){
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isGitRepository = true
                        }
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isGitRepository = false
                        }
                    }
                }
            }
            catch {
                print("\(error)") //handle or silence the error here
            }
        }
    }
    
    
    func commit(){
        withAnimation {
            self.loadingGitFunctionality = true
        }
        
        Task{
            do {
                var command = "cd \(path); "
                for value in values {
                    let filePath = "git add \(path)/\(value.local)/Localizable.strings; "
                    command += filePath
                }
                command += "git commit -m \"new localizable files, commited through LocalizationManager by Vladislav Permyakov\"; git push;"
                print(try safeShell(command))
            }
            catch {
                print("\(error)") //handle or silence the error here
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.loadingGitFunctionality = false
                }
            }
            
        }
    }
    
    func importCSV(_ path: String){
        do{
            var tempVal = [val]()
            //read file lines
            var lines = try String(contentsOfFile: path).components(separatedBy: "\n")
            //check if there is > 0 lines and first line has key title
            guard let firstLine = lines.first?.components(separatedBy: ","), firstLine[0] == "key" else{return}
            for i in 1..<firstLine.count{
                //?????????????? ???????????? ???? ???????????? ?????????????????????? ?????????????????? ?? ??????????
                tempVal.append(val(local: "\(firstLine[i]).lproj", values: [:]))
            }
            //removing first line containing titles and language names
            lines.removeFirst()
            //going through each phrase/word
            lines.forEach { line in
                let components = line.components(separatedBy: ",")
                //checking if there is right amount of elements (key + translations)
                guard components.count == tempVal.count+1 else {return}
                //adding each translation to array
                for i in 1..<components.count{
                    tempVal[i-1][components[0]] = components[i]
                }
            }
            values = tempVal
            saveFiles()
        }catch{}
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

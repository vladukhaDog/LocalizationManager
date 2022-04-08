//
//  ContentView.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import SwiftUI

struct ContentView: View {
    
    
    @AppStorage("lastPath") var projectPath: String = ""
    var body: some View {
        VStack{
            Text(projectPath)
            Button("Выбрать папку с проектом")
            {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                if panel.runModal() == .OK,  panel.url?.absoluteString != nil{
                    self.projectPath = ""
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                        self.projectPath = (panel.url?.path)!
                    }
                    
                }
            }
            if projectPath != ""{
                ScrollView(.horizontal, showsIndicators: false) {
                    LocalizationTable(projectPath)
                }
                
            }
            
                
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
            HStack {
                Text(projectPath)
                    .bold()
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Button {
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
                } label: {
                    Text("Выбрать папку с проектом")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.darkSeaGreen.blur(radius: 4))
                        .cornerRadius(20)
    //                    .shadow(color: .black, radius: 5, x: 0, y: 0)
                }
                .buttonStyle(.plain)
            }
            

            
            
            if projectPath != ""{
                ScrollView(.horizontal, showsIndicators: false) {
                    LocalizationTable(projectPath)
                }
            }
        }
        .background(Color.darkSlateGreen.ignoresSafeArea())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct ContentView_Previews: PreviewProvider {
 
    static var previews: some View {
         ContentView()
     }
 }


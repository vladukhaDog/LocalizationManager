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
                    Text("Выбрать папку")
                        .bold()
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width: 200)
                        .background(Color.darkSeaGreen)
                        .cornerRadius(15)
    //                    .shadow(color: .black, radius: 5, x: 0, y: 0)
                }
                .buttonStyle(.plain)
                Text(projectPath)
                    .bold()
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            

            
            
            if projectPath != ""{
                ScrollView(.horizontal, showsIndicators: false) {
                    LocalizationTable(projectPath)
                }
            }
        }
        .padding()
//        .background(Color.darkSlateGreen.ignoresSafeArea())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct ContentView_Previews: PreviewProvider {
 
    static var previews: some View {
         ContentView()
     }
 }


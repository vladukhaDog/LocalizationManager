//
//  ContentView.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import SwiftUI
import Foundation

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
                        .foregroundColor(.primary)
                        .padding(10)
                        .frame(width: 200)
                        .background(Color.dimGray)
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 4, x: -1, y: 1)
                }
                .buttonStyle(.plain)
                Text(projectPath)
                    .bold()
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.blueLight)
                    .cornerRadius(5)
                Spacer()
            }
            .padding(.horizontal)
            

            
            
            if projectPath != ""{
                ScrollView(.horizontal, showsIndicators: false) {
                    LocalizationTable(projectPath)
                }
            }
        }
        .padding(.vertical)
//        .background(Color.darkSlateGreen.ignoresSafeArea())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct ContentView_Previews: PreviewProvider {
 
    static var previews: some View {
         ContentView()
     }
 }


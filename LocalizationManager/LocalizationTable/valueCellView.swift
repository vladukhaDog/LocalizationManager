//
//  valueCellView.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import SwiftUI

struct valueCellView: View {
    @Binding var values: [val]
    @State private var newValue = ""
    @State private var showingTextField = false
    
    var value: String
    var item: val
    var key: String
    var save: ()->()
    var body: some View {
        VStack{
            Text(value)
                .onTapGesture {
                    withAnimation {
                        showingTextField.toggle()
                    }
                    
                }
            if showingTextField{
                HStack{
                TextField("новое значение", text: $newValue)
                    Button {
                        if let index = values.firstIndex(where: {$0.local == item.local}){
                            values[index].values[key] = newValue
                            save()
                        }
                    } label: {
                        Text("Сохранить")
                    }

                }
                .padding(.horizontal)
            }
        }
            .foregroundColor(.white)
            .frame(width: widthConst, height: heightConst)
            .background(Color.black.onTapGesture {
                withAnimation {
                    showingTextField.toggle()
                }
            })
            .border(Color.gray, width: 1)
        
            
    }
}

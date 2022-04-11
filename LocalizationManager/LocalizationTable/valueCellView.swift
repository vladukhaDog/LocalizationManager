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
            HStack{
                Text(value)
                Spacer()
                Button {
                    withAnimation {
                        showingTextField.toggle()
                    }
                } label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .frame(width: 20, height: 20)
            }
            .padding(.horizontal)
            if showingTextField{
                HStack{
                    TextField("новое значение", text: $newValue)
                    Button {
                        if let index = values.firstIndex(where: {$0.local == item.local}){
                            values[index].values[key] = newValue
                            save()
                            withAnimation {
                                showingTextField.toggle()
                            }
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
        .background(Color.darkSlateBlue.padding(1))
        
    }
}

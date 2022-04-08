//
//  LocalizationTable.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import SwiftUI

struct LocalizationTable: View {
    @StateObject private var vm: LocalizationTableViewModel
    init(_ folderPath: String){
        self._vm = StateObject(wrappedValue: LocalizationTableViewModel(folderPath))
    }
    var body: some View {
        HStack(spacing: 0){
            VStack{
                Text("key")
                HStack{
                    TextField("Новый ключ", text: $vm.newKey)
                    Button {
                        vm.add()
                    } label: {
                        Image(systemName: "plus.app")
                            .resizable()
                            .scaledToFit()
                        
                    }
                    .frame(width: 30, height: 30)
                }
                
            }
            .padding(.horizontal)
            .foregroundColor(Color.green)
            .frame(width: widthConst, height: heightConst)
            .border(Color.gray, width: 1)
            ForEach(vm.values, id: \.self){item in
                Text(item.local)
                    .foregroundColor(Color.green)
                    .frame(width: widthConst, height: heightConst)
                    .border(Color.gray, width: 1)
            }
        }
        ScrollView{
            HStack(spacing: 0){
                VStack(spacing: 0){
                    if vm.values.first != nil{
                        ForEach(vm.values.first!.values.sorted(by: <), id: \.key){key, value in
                            ZStack{
                                HStack{
                                    Button {
                                        vm.remove(key)
                                    } label: {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.red)
                                    }
                                    .frame(width: 30, height: 30)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                Text(key)
                                    .bold()
                                
                                    .frame(width: widthConst, height: heightConst)
                                    .border(Color.gray, width: 1)
                            }
                        }
                    }
                }
                
                ForEach(vm.values, id: \.self){item in
                    VStack(spacing:0){
                        ForEach(item.values.sorted(by: <), id:\.key){key, value in
                            valueCellView(values: $vm.values, value: value, item: item, key: key){
                                vm.saveFiles()
                            }
                            
                        }
                    }
                }
            }
        }
    }
}


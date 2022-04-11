//
//  LocalizationTable.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import SwiftUI


struct LocalizationTable_Previews: PreviewProvider {
    
    static var previews: some View {
        LocalizationTable("test")
    }
}


struct LocalizationTable: View {
    @StateObject private var vm: LocalizationTableViewModel
    init(_ folderPath: String){
        self._vm = StateObject(wrappedValue: LocalizationTableViewModel(folderPath))
    }
    var body: some View {
        VStack{
            HStack{
                HStack{
                    TextField("Новый ключ", text: $vm.newKey)
                        .textFieldStyle(.plain)
                    Button {
                        vm.add()
                        vm.searchKey = vm.newKey
                    } label: {
                        Image(systemName: "plus.app")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 20, height: 20)
                }
                .padding(8)
                .frame(width: 200)
                .background(Color.lightCoral)
                .cornerRadius(10)
                Spacer()
            }
            .padding(.bottom)
            VStack(spacing: 0){
                HStack(spacing: 0){
                    VStack{
                        Text("key").bold()
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .background(Color.lightCoral)
                    .cornerRadius(15)
                    .background(Color.lightCoral.padding(.top, 10))
                    .frame(width: widthConst)
                    
                    ForEach(vm.values, id: \.self){item in
                        Text(item.local).bold()
                            .padding(.horizontal)
                            .foregroundColor(Color.white)
                            .background(Color.lightCoral)
                            .cornerRadius(15)
                            .background(Color.lightCoral.padding(.top, 10))
                            .frame(width: widthConst)
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
                                            .buttonStyle(.plain)
                                            .frame(width: 20, height: 20)
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        Text(key)
                                            .foregroundColor(.white)
                                            .bold()
                                            .frame(width: widthConst, height: heightConst)
                                    }
                                    .background(key == vm.searchKey ? Color.orange.padding(1) : Color.lightSeaGreen.padding(1))
                                    
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
                    
                    .cornerRadius(15)
                }
                .cornerRadius(15)
            }
        }
        .padding()
    }
}

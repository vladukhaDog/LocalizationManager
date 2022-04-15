//
//  LocalizationTable.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import SwiftUI
import Dispatch

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
            ScrollViewReader{ scrollView in
            HStack{
                HStack{
                    TextField("Новый ключ", text: $vm.newKey)
                        .textFieldStyle(.plain)
                        .onSubmit {
                            vm.add()
                            vm.searchKey = vm.newKey
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    scrollView.scrollTo(vm.newKey, anchor: .center)
                                }
                            }
                        }
                    Button {
                        vm.add()
                        vm.searchKey = vm.newKey
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                scrollView.scrollTo(vm.newKey, anchor: .center)
                            }
                        }
                        
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
                .background(Color.dimGray)
                .cornerRadius(10)
                Spacer()
            }
            .padding(.bottom)
            VStack(spacing: 0){
                //строка именующая столбики
                HStack(spacing: 0){
                    VStack{
                        Text("key").bold()
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .background(Color.dimGray)
                    .cornerRadius(15)
                    .background(Color.dimGray.padding(.top, 10))
                    .frame(width: widthConst)
                    //имена локализаций столбиков
                    ForEach(vm.values, id: \.self){item in
                        Text(item.local).bold()
                            .padding(.horizontal)
                            .foregroundColor(Color.white)
                            .background(Color.dimGray)
                            .cornerRadius(15)
                            .background(Color.dimGray.padding(.top, 10))
                            .frame(width: widthConst)
                    }
                }
                ScrollView{
                    HStack(spacing: 0){
                        //Столбик с ключами переводов
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
                                    .background(key == vm.searchKey ? Color.orange.padding(1) : Color.lightSlateBlue.padding(1))
                                    .id(key)
                                }
                            }
                        }
                        //Перечисление переводов
                        ForEach(vm.values, id: \.self){item in
                            //Столбик с переводами по ключам
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
        }
        .padding()
    }
}


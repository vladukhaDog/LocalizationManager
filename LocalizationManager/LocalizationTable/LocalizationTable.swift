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
                HStack {
                    HStack{
                        
                        //Кнопка для комита и
                        Button {
                            vm.commit()
                        } label: {
                                Label("Commit&Push", systemImage: "icloud.and.arrow.up.fill")
                                    .foregroundColor(.white)
                            
                            .padding(8)
                            .background(Color.green)
                        }
                        .buttonStyle(.plain)
                        .disabled(!vm.isGitRepository)
                        .overlay(ZStack{
                            if vm.loadingGitFunctionality{
                                Color.black.opacity(0.61)
                                    .blur(radius: 10)
                                ProgressView()
                            }
                        })
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, x: -1.5, y: 1.5)
                        if !vm.isGitRepository{
                            Text("Не гит репозиторий!")
                                .foregroundColor(.white)
                                .bold()
                        }
                        HStack{
                            Image(systemName: "magnifyingglass")
                            TextField("Поиск", text: $vm.searchKey, onEditingChanged: {val in
                            })
                            .textFieldStyle(.plain)
                            .onSubmit {
                                //                            vm.searchKey = vm.newKey
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        scrollView.scrollTo(vm.searchKey, anchor: .center)
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(Color.dimGray)
                        .cornerRadius(10)
                        .padding(.horizontal)
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
                                    .foregroundColor(.primary)
                            }
                            .buttonStyle(.plain)
                            .frame(width: 15, height: 15)
                        }
                        .padding(8)
                        .frame(width: 200)
                        .background(Color.dimGray)
                        .cornerRadius(10)
                        
                    }
                    .padding(.bottom)
                    .frame(width: 800)
                    Spacer()
                }
                
                VStack(spacing: 0){
                    //строка именующая столбики
                    HStack(spacing: 0){
                        VStack{
                            Text("key").bold()
                        }
                        .padding(.horizontal)
                        .foregroundColor(Color.primary)
                        .background(Color.dimGray)
                        .cornerRadius(15)
                        .background(Color.dimGray.padding(.top, 10))
                        .frame(width: widthConst)
                        //имена локализаций столбиков
                        ForEach(vm.values, id: \.self){item in
                            Text(item.local).bold()
                                .padding(.horizontal)
                                .foregroundColor(Color.primary)
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
                                                .foregroundColor(.primary)
                                                .bold()
                                                .frame(width: widthConst, height: heightConst)
                                        }
                                        .background(key.contains(vm.searchKey) ? Color.orange.padding(1) : Color.lightSlateBlue.padding(1))
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


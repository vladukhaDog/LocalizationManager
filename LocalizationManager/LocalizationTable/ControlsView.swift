//
//  ControlsView.swift
//  LocalizationManager
//
//  Created by Владислав Пермяков on 20.04.2022.
//

import SwiftUI

struct ControlsView: View {
    @StateObject var vm: LocalizationTableViewModel
    var scrollView:  ScrollViewProxy
    var body: some View {
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
    }
}

//struct ControlsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlsView()
//    }
//}

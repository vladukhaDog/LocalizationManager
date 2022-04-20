//
//  KeyCellView.swift
//  LocalizationManager
//
//  Created by Владислав Пермяков on 20.04.2022.
//

import SwiftUI

struct KeyCellView: View {
    @StateObject var vm: LocalizationTableViewModel
    var key: String
    var value: String
    var body: some View {
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

//struct KeyCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyCellView()
//    }
//}

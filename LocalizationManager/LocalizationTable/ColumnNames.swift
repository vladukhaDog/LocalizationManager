//
//  ColumnNames.swift
//  LocalizationManager
//
//  Created by Владислав Пермяков on 20.04.2022.
//

import SwiftUI

struct ColumnNames: View {
    @StateObject var vm: LocalizationTableViewModel
    var body: some View {
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
    }
}

//struct ColumnNames_Previews: PreviewProvider {
//    static var previews: some View {
//        ColumnNames()
//    }
//}

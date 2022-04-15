//
//  valueCellView.swift
//  LocalizationManager
//
//  Created by Permyakov Vladislav on 08.04.2022.
//

import SwiftUI
struct valueCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        valueCellView(values: .constant([val(local: "ru", values: ["key":"val"])]), value: "val", item: val(local: "ru", values: ["key":"val"]), key: "key", save: {})
    }
}

struct valueCellView: View {
    @Binding var values: [val]
    @State private var newValue = ""
    @State private var showingTextField = false
    @FocusState private var focusOnEditor: Bool
    var value: String
    var item: val
    var key: String
    var save: ()->()
    var body: some View {
        ZStack{
            
            if showingTextField{
                HStack{
                    if newValue.count < 27{
                        TextField("новое значение", text: $newValue)
                            .textFieldStyle(.plain)
                            .focused($focusOnEditor)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  /// Anything over 0.5 seems to work
                                    self.focusOnEditor = true
                                }
                            }
                            .onSubmit {
                                if let index = values.firstIndex(where: {$0.local == item.local}){
                                    values[index].values[key] = newValue
                                    save()
                                    withAnimation {
                                        showingTextField.toggle()
                                    }
                                }
                            }
                        //                        .background(Color.red)
                    }else{
                        TextEditor(text: $newValue)
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($focusOnEditor)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  /// Anything over 0.5 seems to work
                                    self.focusOnEditor = true
                                }
                            }
                            
                    }
                    HStack{
                        Button {
                            if let index = values.firstIndex(where: {$0.local == item.local}){
                                values[index].values[key] = newValue
                                save()
                                withAnimation {
                                    showingTextField.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .padding(4)
                                .background(Color.dimGray)
                                .cornerRadius(5)
                        }
                        .buttonStyle(.plain)
                        Button {
                            withAnimation {
                                showingTextField.toggle()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .padding(4)
                                .background(Color.dimGray)
                                .cornerRadius(5)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(5)
                .background(Color.darkSlateBlueComp)
                .cornerRadius(5)
                .padding()
                .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
            }
            if !showingTextField{
                HStack{
                    Text(value)
                    Spacer()
                    Button {
                        withAnimation {
                            showingTextField.toggle()
                            newValue = value
                        }
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.dimGray)
                            .cornerRadius(5)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .bottom).combined(with: .opacity)))
                //                .transition(.move(edge: .top))
            }
        }
        .foregroundColor(.white)
        .frame(width: widthConst, height: heightConst)
        .background(Color.darkSlateBlue.padding(1))
        
    }
}


extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear //<<here clear
            drawsBackground = true
        }

    }
}

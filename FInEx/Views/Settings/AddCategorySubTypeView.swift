//
//  AddCategoryView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-08.
//

import SwiftUI
import Introspect

struct AddCategorySubTypeView: View {
    @EnvironmentObject var userSettingsVM: UserSettingsManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var category: String
    @State private var newtypeName: String = ""
    @State private var appearanceImageName: String = "questionmark"
    @State private var appearanceCircleColor: String = "TopGradient"
    @State private var showIcons: Bool = true
    @State private var selectedSubCategory: String = ""
    private let appearanceColorSet = ["CustomRed", "CustomPink", "CustomPurple", "CustomGreen", "CustomBlue", "CustomYellow"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView() {
                    let subCategories = userSettingsVM.subCategories[self.category] ?? []
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CATEGORY")
                            .font(Font.system(size: 12, weight: .light, design: .default))
                        Text(self.category)
                            .font(Font.system(size: 24, weight: .light, design: .default))
                    }
                    .padding()
                    .frame(width: geo.size.width, alignment: .leading)
                    //.navigationBarTitle (Text(""), displayMode: .inline)
                    VStack(alignment: .leading, spacing: 8) {
                       HStack {
                            Text("SUB CATEGORY")
                                .font(Font.system(size: 12, weight: .light, design: .default))
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(Color.red)
                                Picker("CHANGE",
                                       selection: self.$selectedSubCategory) {
                                    ForEach(0..<subCategories.count) { index in
                                        Text(subCategories[index]).tag(subCategories[index])
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .font(Font.system(size: 12, weight: .light, design: .default))
                            }
                            .frame(width: geo.size.width / 4, height: 20, alignment: .center)
                        }
                        Text("\(self.selectedSubCategory)")
                            .font(Font.system(size: 24, weight: .light, design: .default))
                    }
                    .padding()
                    .frame(width: geo.size.width, height: subCategories.isEmpty ? 0 : 80 , alignment: .leading)
                    .opacity(subCategories.isEmpty ? 0 : 1)
                    .onAppear {
                        if !subCategories.isEmpty {
                            self.selectedSubCategory = subCategories.first!
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("NAME")
                            .font(Font.system(size: 12, weight: .light, design: .default))
                        TextField("Required", text: self.$newtypeName, onEditingChanged: {isEditing in if isEditing {
                            self.showIcons = false
                        } else { self.showIcons = true }} , onCommit:  {
                            
                        })
                            .accentColor(.gray)
                            .introspectTextField { textField in
                                    textField.becomeFirstResponder()
                            }
                            .font(Font.system(size: 22, weight: .light, design: .default))
                            
                    }
                    .padding()
                    .frame(width: geo.size.width, alignment: .leading)
                    
                    
                    VStack(alignment: .leading) {
                        Text("APPEARANCE")
                            .font(Font.system(size: 12, weight: .light, design: .default))
                        Image(systemName: self.appearanceImageName)
                            .foregroundColor(.white)
                            .modifier(CircleModifierSimpleColor(color: Color(self.appearanceCircleColor), strokeLineWidth: 3.0))
                            .font(Font.system(size: 24, weight: .regular, design: .default))
                            .frame(width: geo.size.width / 8, height: geo.size.width / 8, alignment: .center)
                            .onTapGesture {
                                self.showIcons.toggle()
                            }
                            
                        HStack(spacing: 15) {
                            ForEach(0..<self.appearanceColorSet.count) { index in
                                Text("")
                                    .modifier(CircleModifierSimpleColor(color: Color(self.appearanceColorSet[index]), strokeLineWidth: 3.0))
                                    .frame(width: geo.size.width / 10, height: geo.size.width / 10, alignment: .center)
                                    .onTapGesture {
                                        self.appearanceCircleColor = self.appearanceColorSet[index]
                                    }
                            }
                        }
                        .padding()
                    }
                    .padding()
                    .frame(width: geo.size.width, alignment: .leading)
                    VStack {
                        Button(action: {
                            save()
                            
                        }) {
                            SaveButtonView(geo: geo)
                        }
                    }
                    .frame(width: geo.size.width, height: 150, alignment: .bottom)
                    .opacity(self.showIcons ? 0 : 1)
                    
                }
                .foregroundColor(Color("TextDarkGray"))
                
                .overlay(
                    IconsView(appearanceImageName: self.$appearanceImageName, geo: geo)
                        .opacity(self.showIcons ? 1 : 0)
                )
            }
            .onTapGesture {
                hideKeyboard()
                self.showIcons.toggle()
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                    .font(Font.system(size: 20, weight: .regular, design: .default))
            })
            
        }
    }
    private func save() {
        let newTransactionTypeInfo = TransactionTypeInfo(
            category: category,
            subCategory: category == Categories.Income ? nil : selectedSubCategory,
            name: newtypeName,
            imageName: appearanceImageName,
            colorName: appearanceCircleColor,
            isHidden: false)
        userSettingsVM.addNewTransactiontype(info: newTransactionTypeInfo, context: viewContext)
        self.userSettingsVM.getTransactiontypes(context: viewContext)
        presentationMode.wrappedValue.dismiss()
    }
    
    
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategorySubTypeView(category: .constant("Income") )
    }
}

enum SubCategories: String, CaseIterable {
    case Entertainment = "er"
    case Health
    case Insurance
    case Travel
    case Bills

    //var id: String { self.rawValue }
}




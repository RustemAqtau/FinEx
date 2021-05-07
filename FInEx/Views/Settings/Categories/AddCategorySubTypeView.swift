//
//  AddCategoryView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-08.
//

import SwiftUI
import Introspect

struct AddCategorySubTypeView: View {
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @EnvironmentObject var userSettingsVM: UserSettingsManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var category: String
    @State private var newtypeName: String = NSLocalizedString("", comment: "")
    @State private var appearanceImageName: String = CategoryIconNamesCustom.questionMark.rawValue
    @State private var appearanceCircleColor: String = "TextLightGray"
    @State private var showIcons: Bool = true
    @State private var selectedSubCategory: String = NSLocalizedString("", comment: "")
    @State private var warningMessage: String = ""
    @State private var validationFailed: Bool = false
    @State private var height: CGFloat = 0
    @State private var saveButtonOffsetY: CGFloat = 30
    
    private let appearanceColorSet = ["CustomRed", "CustomPink", "CustomPurple", "CustomGreen", "CustomBlue", "CustomYellow"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView() {
                    VStack(spacing: 8) {
                        Text(warningMessage)
                            .font(Fonts.light12)
                            .foregroundColor(.gray)
                            .opacity(self.validationFailed ? 1 : 0)
                            .frame(height: self.validationFailed ? 20 : 0)
                        
                        let subCategories = userSettingsVM.subCategories[self.category] ?? []
                        VStack(alignment: .leading, spacing: 3) {
                            Text(LocalizedStringKey("CATEGORY"))
                                .font(Fonts.light12)
                            Text(LocalizedStringKey(self.category))
                                .font(Fonts.light25)
                        }
                        .padding(.horizontal)
                        .frame(width: geo.size.width, alignment: .leading)
                        
                        .navigationBarTitle (Text(""), displayMode: .inline)
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text(LocalizedStringKey("SUBCATEGORY"))
                                    .font(Font.system(size: 12, weight: .light, design: .default))
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.red)
                                    Picker(LocalizedStringKey("CHANGE"),
                                           selection: self.$selectedSubCategory) {
                                        ForEach(0..<subCategories.count) { index in
                                            Text(LocalizedStringKey(subCategories[index])).tag(subCategories[index])
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .font(Font.system(size: 12, weight: .light, design: .default))
                                }
                                .frame(width: geo.size.width / 4, height: 20, alignment: .center)
                            }
                            Text(LocalizedStringKey("\(self.selectedSubCategory)"))
                                .font(Font.system(size: 24, weight: .light, design: .default))
                        }
                        .padding(.horizontal)
                        .frame(width: geo.size.width, height: subCategories.isEmpty ? 0 : 80 , alignment: .leading)
                        .opacity(subCategories.isEmpty ? 0 : 1)
                        .onAppear {
                            if !subCategories.isEmpty {
                                self.selectedSubCategory = subCategories.first!
                            }
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text(LocalizedStringKey("NAME"))
                                .font(Font.system(size: 12, weight: .light, design: .default))
                            TextField(LocalizedStringKey(Placeholders.Required.localizedString()), text: self.$newtypeName, onEditingChanged: {isEditing in if isEditing {
                                
                                self.showIcons = false
                                self.height = geo.size.height
                                replaceSaveButton(down: false)
                                
                            } else { self.showIcons = true }} , onCommit:  {
                                
                            })
                            .accentColor(.gray)
                            .disableAutocorrection(true)
                            .introspectTextField { textField in
                               // textField.becomeFirstResponder()
                                if self.showIcons {
                                    textField.resignFirstResponder()
                                }
                            }
                            .font(Font.system(size: 22, weight: .light, design: .default))
                        }
                        .padding(.horizontal)
                        .frame(width: geo.size.width, height: 60, alignment: .top)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(LocalizedStringKey("APPEARANCE"))
                                .font(Fonts.light12)
                            HStack {
                                Image(self.appearanceImageName)
                                    .foregroundColor(.white)
                                    .modifier(CircleModifierSimpleColor(color: Color(self.appearanceCircleColor), strokeLineWidth: 3.0))
                                    .font(Font.system(size: 24, weight: .regular, design: .default))
                                    .frame(width: geo.size.width / 8, height: geo.size.width / 8, alignment: .center)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                       // hideKeyboard()
                                        replaceSaveButton(down: false)
                                        self.showIcons = true
                                        }
                                    }
                                
                                HStack(spacing: 10) {
                                    ForEach(0..<self.appearanceColorSet.count) { index in
                                        Text("")
                                            .modifier(CircleModifierSimpleColor(color: Color(self.appearanceColorSet[index]), strokeLineWidth: 2.0))
                                            .frame(width: geo.size.width / 11, height: geo.size.width / 11, alignment: .center)
                                            .onTapGesture {
                                                self.appearanceCircleColor = self.appearanceColorSet[index]
                                            }
                                    }
                                }
                                .padding()
                            }
                            
                        }
                        .padding(.horizontal)
                        .frame(width: geo.size.width,  alignment: .leading)
                        
                        
                        Button(action: {
                            if validationSucceed() {
                                save()
                            }
                        }) {
                            SaveButtonView(geo: geo, withTrash: false, withdraw: false)
                        }
                       // .offset(y: self.saveButtonOffsetY)
                        //.offset(y: -self.keyboardHeightHelper.keyboardHeight)
                    }
                    
                }
                .foregroundColor(CustomColors.TextDarkGray)
                
                .overlay(
                    IconsView(appearanceImageName: self.$appearanceImageName, geo: geo)
                        .opacity(self.showIcons ? 1 : 0)
                )
            }
            .background(CustomColors.White_Background)
            .ignoresSafeArea(.all, edges: .bottom)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                hideKeyboard()
                replaceSaveButton(down: true)
                self.showIcons = false
                }
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                    .font(Font.system(size: 20, weight: .regular, design: .default))
            })
            .onChange(of: self.newtypeName, perform: { value in
                validationFailed = false
            })
            .onChange(of: self.appearanceImageName, perform: { value in
                validationFailed = false
            })
        }
        .accentColor(CustomColors.TextDarkGray)
    }
    
    private func replaceSaveButton(down: Bool) {
        
        withAnimation(.easeInOut(duration: 0.5)) {
            self.saveButtonOffsetY = down ? self.keyboardHeightHelper.keyboardHeight  : -self.keyboardHeightHelper.keyboardHeight
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
        self.userSettingsVM.getAllTransactiontypes(context: viewContext)
        presentationMode.wrappedValue.dismiss()
    }
    func validationSucceed() -> Bool {
        
        guard !self.newtypeName.isEmpty else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.RequiredField.localizedString()
            return false
        }
        guard self.appearanceImageName != Icons.Questionmark else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.RequiredField.localizedString()
            return false
        }
        return true
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





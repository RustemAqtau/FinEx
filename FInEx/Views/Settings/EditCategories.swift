//
//  EditCategories.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-08.
//

import SwiftUI

struct EditCategories: View {
    @EnvironmentObject var userSettingsVM: UserSettingsManager
    @Environment(\.managedObjectContext) private var viewContext
    @State var isAddingCategory: Bool = false
    @State var isExpense: Bool = true
    @State var addingCategory: String = ""
    @State var selectedCategory: String = Categories.Income
    @State var selectedSubCategories: [String]? //= []
    let categories = [0, 1, 2]
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                Group {
                    VStack {
                    }
                    .frame(width: geo.size.width, height: 20, alignment: .center)
                    .ignoresSafeArea(.all, edges: .top)
                    .navigationBarTitle (Text(""), displayMode: .large)
                    VStack {
                        VStack {
                            Picker(selection: self.$selectedCategory, label: Text("")) {
                                Text(LocalizedStringKey(Categories.Income)).tag(Categories.Income)
                                Text(LocalizedStringKey(Categories.Expense)).tag(Categories.Expense)
                                Text(LocalizedStringKey(Categories.Saving)).tag(Categories.Saving)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorMultiply(CustomColors.IncomeGradient2).colorInvert()
                            .colorMultiply(CustomColors.CloudBlue).colorInvert()
                        }
                        .frame(width: geo.size.width)
                        HStack {
//                                        Text(LocalizedStringKey(self.selectedCategory))
//                                            .font(Font.system(size: 25, weight: .regular, design: .default))
//
//                                        Spacer()
                            Button(action: {
                                self.addingCategory = self.selectedCategory
                                self.isAddingCategory = true
                            }) {
                                Text(LocalizedStringKey("ADD NEW"))
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    .font(Font.system(size: 16, weight: .regular, design: .default))
                                    .frame(width: geo.size.width, height: 30, alignment: .center)
                                
                            }.sheet(isPresented: $isAddingCategory, content: {
                                withAnimation(.easeInOut(duration: 2)) {
                                    AddCategorySubTypeView(category: self.$addingCategory)
                                        .environmentObject(userSettingsVM)
                                }
                            })
                        }
                        ScrollView {
                                VStack {
                                    
                                    if self.selectedSubCategories != nil {
                                        if self.selectedSubCategories!.isEmpty {
                                            let types = userSettingsVM.transactiontypesByCategoty[self.selectedCategory]![""]!
                                            ForEach(0..<types.count, id: \.self) { index in
                                                    HStack(alignment: .center, spacing: 0) {
                                                        Button(action: {}) {
                                                            Image(systemName: "minus.circle.fill")
                                                                .foregroundColor(.red)
                                                                .font(Font.system(size: 20, weight: .regular, design: .default))
                                                                .frame(width: geo.size.width / 12, height: geo.size.width / 11, alignment: .center)
                                                        }
                                                        Group {
                                                            Image(systemName: types[index].presentingImageName)
                                                                .foregroundColor(.white)
                                                                .modifier(CircleModifierSimpleColor(color: Color(types[index].presentingColorName), strokeLineWidth: 3.0))
                                                                .frame(width: geo.size.width / 12, height: geo.size.width / 10, alignment: .center)
                                                                .padding()
                                                            Text(LocalizedStringKey(types[index].presentingName))
                                                        }
                                                    }
                                                    .frame(width: geo.size.width * 0.95, height: 35, alignment: .leading)
                                                    
                                                    Divider()
                                                }
                                        } else {
                                            ForEach(self.selectedSubCategories!, id: \.self) { subCategory in
                                                    HStack {
                                                        Text(LocalizedStringKey(subCategory))
                                                            .font(Font.system(size: 18, weight: .light, design: .default))
                                                        
                                                    }
                                                    .padding()
                                                    .frame(width: geo.size.width, height: 30, alignment: .leading)
                                                    
                                                    Divider()
                                                if let types = userSettingsVM.transactiontypesByCategoty[self.selectedCategory]![subCategory] {
                                                    ForEach(types, id: \.self) { type in
                                                        
                                                        HStack(alignment: .center, spacing: 0) {
                                                            Button(action: {}) {
                                                                Image(systemName: "minus.circle.fill")
                                                                    .foregroundColor(.red)
                                                                    .font(Font.system(size: 20, weight: .regular, design: .default))
                                                                    .frame(width: geo.size.width / 12, height: geo.size.width / 11, alignment: .center)
                                                                   
                                                            }
                                                            Image(systemName: type.presentingImageName)
                                                                .foregroundColor(.white)
                                                                .modifier(CircleModifierSimpleColor(color: Color(type.presentingColorName), strokeLineWidth: 3.0))
                                                                .frame(width: geo.size.width / 12, height: geo.size.width / 10, alignment: .center)
                                                                .padding()
                                                            Text(LocalizedStringKey(type.presentingName))
                                                                
                                                            
                                                        }
                                                        .frame(width: geo.size.width * 0.95, height: 35, alignment: .leading)
                                                        
                                                        Divider()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(width: geo.size.width)
                                .scaledToFit()
                                .foregroundColor(CustomColors.TextDarkGray)
                               // .transition(AnyTransition.slide)
                            VStack {
                            }
                            .frame(width: geo.size.width, height: geo.size.height / 3, alignment: .center)
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                    }
                    
                }
                .background(Color.white)
                .onAppear {
                    self.userSettingsVM.getTransactiontypes(context: viewContext)
                    self.selectedSubCategories = userSettingsVM.subCategories[self.selectedCategory]
                }
                .onChange(of: self.selectedCategory, perform: { value in
                    withAnimation(.easeIn(duration: 0.5)) {
                    self.selectedSubCategories = userSettingsVM.subCategories[self.selectedCategory]
                    }
                })
            }
        }
    }
}

struct EditCategories_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditCategories()
            EditCategories()
                .preferredColorScheme(.dark)
        }
    }
}

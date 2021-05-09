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
    @Environment(\.presentationMode) var presentationMode
    @State var isAddingCategory: Bool = false
    @State var isExpense: Bool = true
    @State var addingCategory: String = ""
    @State var selectedCategory: String = Categories.Income
    @State var selectedSubCategories: [String]?
    @State var hideButtonName: String = "minus.circle.fill"
    @State var showHideButton: Bool = false
    let categories = [0, 1, 2]
    @Binding var  hideTabBar: Bool
    var body: some View {
        
            GeometryReader { geo in
                Group {
                    VStack {
                    }
                    .frame(width: geo.size.width, height: 0, alignment: .center)
                    .ignoresSafeArea(.all, edges: .top)
                    .navigationBarTitle (Text(""), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.addingCategory = self.selectedCategory
                        self.isAddingCategory = true
                        
                    }) {
                        Image(systemName: "plus.circle")
                            .font(Font.system(size: 20, weight: .regular, design: .default))
                    })
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
                        .foregroundColor(CustomColors.TextDarkGray)

                        ScrollView {
                                VStack {
                                    if self.selectedSubCategories != nil {
                                        if self.selectedSubCategories!.isEmpty {
                                            let types = userSettingsVM.allTransactionTypesByCategoty[self.selectedCategory]![""]!
                                            ForEach(0..<types.count, id: \.self) { index in
                                                    HStack(alignment: .center, spacing: 0) {
                                                        Button(action: {
                                                            
                                                        }) {
                                                            Image(systemName: "minus.circle.fill")
                                                                .foregroundColor(.red)
                                                                .font(Font.system(size: 20, weight: .regular, design: .default))
                                                                .frame(width: geo.size.width / 12, height: geo.size.width / 11, alignment: .center)
                                                        }
                                                        Group {
                                                            Image(types[index].presentingImageName)
                                                                .foregroundColor(.white)
                                                                .modifier(CircleModifierSimpleColor(color: Color(types[index].presentingColorName), strokeLineWidth: 3.0))
                                                                .frame(width: geo.size.width / 12, height: geo.size.width / 10, alignment: .center)
                                                                .padding()
                                                            Text(LocalizedStringKey(types[index].presentingName))
                                                            
                                                        }
                                                        .frame(width: geo.size.width * 0.60)
                                                        Button(action: {
                                                            
                                                        }) {
                                                            Image(systemName: "circle.fill")
                                                                .foregroundColor(.red)
                                                                .font(Font.system(size: 20, weight: .regular, design: .default))
                                                                .frame(width: geo.size.width / 12, height: geo.size.width / 11, alignment: .center)
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
                                                if let types = userSettingsVM.allTransactionTypesByCategoty[self.selectedCategory]![subCategory] {
                                                    ForEach(types, id: \.self) { type in
                                                        
                                                        HStack(alignment: .center, spacing: 0) {
                                                            Button(action: {
                                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                                    type.toggleIsHidden(context: viewContext)
                                                                    self.showHideButton.toggle()
                                                                }
                                                            }) {
                                                                Image(systemName: type.isHidden ? "plus.circle.fill" : "minus.circle.fill" )
                                                                    .foregroundColor(type.isHidden ? .green : .red)
                                                                    .font(Font.system(size: 20, weight: .regular, design: .default))
                                                                    .frame(width: geo.size.width * 0.10, height: geo.size.width * 0.15, alignment: .center)
                                                                   
                                                            }
                                                            Group {
                                                                Image( type.presentingImageName)
                                                                    .foregroundColor(.white)
                                                                    .modifier(CircleModifierSimpleColor(color: Color(type.presentingColorName), strokeLineWidth: 3.0))
                                                                    .frame(width: 41, height: 41, alignment: .center)
                                                                    .padding()
                                                                Text(LocalizedStringKey(type.presentingName))
                                                                    .multilineTextAlignment(.leading)
                                                                    .frame(width: geo.size.width * 0.55, alignment: .leading)
                                                            }
                                                            .disabled(type.isHidden)
                                                            .opacity(type.isHidden ? 0.5 : 1)
                                                            .onTapGesture {
                                                                print("enable")
                                                            }
                                                        }
                                                        .padding(.vertical)
                                                        .frame(width: geo.size.width, height: 35, alignment: .leading)
                                                        
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
                                
                                .transition(AnyTransition.asymmetric(
                                                insertion: AnyTransition.opacity.combined(with: .slide),
                                                removal: .move(edge: .leading))
                                            )
                                
                            VStack {
                            }
                            .frame(width: geo.size.width, height: geo.size.height / 3, alignment: .center)
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                    }
                    
                }
                .background(CustomColors.White_Background)
                .ignoresSafeArea(.all, edges: .bottom)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                                        Button(action: {
                                            presentationMode.wrappedValue.dismiss()
                                            self.hideTabBar = false
                                            
                                        }) {
                                            Image(systemName: "chevron.backward")
                                        }
                )
                .onAppear {
                    self.hideTabBar = true
                    self.userSettingsVM.getAllTransactiontypes(context: viewContext)
                    self.selectedSubCategories = userSettingsVM.subCategories[self.selectedCategory]
                    
                }
                .onChange(of: self.selectedCategory, perform: { value in
                    self.hideTabBar = true
                    withAnimation(.easeIn(duration: 0.5)) {
                    self.selectedSubCategories = userSettingsVM.subCategories[self.selectedCategory]
                    }
                })
                .onChange(of: self.showHideButton, perform: { value in
                    self.hideTabBar = true
                    self.selectedSubCategories = userSettingsVM.subCategories[self.selectedCategory]
                })
                .sheet(isPresented: $isAddingCategory, content: {
                    withAnimation(.easeInOut(duration: 2)) {
                        AddCategorySubTypeView(category: self.$addingCategory)
                            .environmentObject(userSettingsVM)
                    }
                })
            }
        
    }
}


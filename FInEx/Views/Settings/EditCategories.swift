//
//  EditCategories.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-08.
//

import SwiftUI

struct EditCategories: View {
    @EnvironmentObject var userSettingsVM: UserSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @State var isAddingCategory: Bool = false
    @State var isExpense: Bool = true
    @State var addingCategory: String = ""
    let categories = [0, 1, 2]
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                Group {
                    VStack {
                        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 4.5, alignment: .center)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("TopGradient"), Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                    .ignoresSafeArea(.all, edges: .top)
                    .navigationBarTitle (Text(""), displayMode: .inline)
                    
                    ScrollView {
                        ForEach(userSettingsVM.categories, id: \.self) { category in
                            let subCategories = userSettingsVM.subCategories[category] ?? []
                            VStack {
                                HStack {
                                    Text(category)
                                        .font(Font.system(size: 25, weight: .regular, design: .default))
                                    
                                    Spacer()
                                    Button(action: {
                                        self.addingCategory = category
                                        self.isAddingCategory = true
                                    }) {
                                        Image(systemName: "plus")
                                    }.sheet(isPresented: $isAddingCategory, content: {
                                        withAnimation(.easeInOut(duration: 2)) {
                                            AddCategorySubTypeView(category: self.$addingCategory)
                                                .environmentObject(userSettingsVM)
                                        }
                                        
                                    })
                                    
                                }
                                .padding()
                                if subCategories.isEmpty {
                                    let types = userSettingsVM.transactiontypesByCategoty[category]![""]!
                                    
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
                                                        .modifier(CircleModifier(color: Color(types[index].presentingColorName), strokeLineWidth: 3.0))
                                                        .frame(width: geo.size.width / 12, height: geo.size.width / 10, alignment: .center)
                                                        .padding()
                                                    Text(types[index].presentingName)
                                                }
                                                
                                                
                                            }
                                            .frame(width: geo.size.width * 0.95, height: 35, alignment: .leading)
                                            
                                            Divider()
                                        }
                                    
                                    
                                    
                                } else {
                                    ForEach(0..<subCategories.count) { index in
                                        let subCategory = subCategories[index]
                                        let types = userSettingsVM.transactiontypesByCategoty[category]![subCategory]!
                                        HStack {
                                            Text(subCategory)
                                                .font(Font.system(size: 18, weight: .light, design: .default))
                                            
                                        }
                                        .padding()
                                        .frame(width: geo.size.width, height: 30, alignment: .leading)
                                        
                                        Divider()
                                        
                                        ForEach(0..<types.count) { index in
                                            
                                            HStack(alignment: .center, spacing: 0) {
                                                Button(action: {}) {
                                                    Image(systemName: "minus.circle.fill")
                                                        .foregroundColor(.red)
                                                        .font(Font.system(size: 20, weight: .regular, design: .default))
                                                        .frame(width: geo.size.width / 12, height: geo.size.width / 11, alignment: .center)
                                                       
                                                }
                                                Image(systemName: types[index].presentingImageName)
                                                    .foregroundColor(.white)
                                                    .modifier(CircleModifier(color: Color(types[index].presentingColorName), strokeLineWidth: 3.0))
                                                    .frame(width: geo.size.width / 12, height: geo.size.width / 10, alignment: .center)
                                                    .padding()
                                                Text(types[index].presentingName)
                                                    
                                                
                                            }
                                            .frame(width: geo.size.width * 0.95, height: 35, alignment: .leading)
                                            
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .frame(width: geo.size.width)
                            .scaledToFit()
                            .foregroundColor(Color("TextDarkGray"))
                            
                        }
                        
                        VStack {
                            
                        }
                        
                        .frame(width: geo.size.width, height: geo.size.height / 3, alignment: .center)
                    }
                    
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                .background(Color.white)
                .onAppear {
                    self.userSettingsVM.getTransactiontypes(context: viewContext)
                }
                
            }
        }
        //.navigationViewStyle(DoubleColumnNavigationViewStyle())
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

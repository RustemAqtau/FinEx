//
//  CategotySelector.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-15.
//

import SwiftUI

struct CategotySelector: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.presentationMode) var presentationMode
    @State var subCategories: [String] = []
    @State var types: [String:[TransactionType]] = [:]
    
    var categoty: String
    @Binding var selectedType: TransactionType
    @Binding var selectedtypeImageName: String
    @Binding var selectedTypeCircleColor: String
    @Binding var selectedTypeName: String
    
    var body: some View {
        
        VStack(spacing: 25) {
            Text(categoty.capitalized)
                .font(Font.system(size: 26, weight: .light, design: .default))
            GeometryReader { geo in
                ScrollView {
                    ForEach(self.subCategories, id: \.self) { subCategory in
                        VStack(alignment: .center, spacing: 15) {
                           let rowCounter = types[subCategory]!.count / 3
                            let modula = types[subCategory]!.count % 3
                            HStack {
                                Text(subCategory)
                                    .font(Font.system(size: 22, weight: .light, design: .default))
                            }
                            .frame(width: geo.size.width * 0.80, alignment: .leading)
                            Divider()
                            Grid(self.types[subCategory]!, viewForItem: { transactionType in
                                VStack {
                                    Image(systemName: transactionType.presentingImageName)
                                        .modifier(CircleModifierSimpleColor(color: Color(transactionType.presentingColorName), strokeLineWidth: 3.0))
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                    Text(transactionType.presentingName)
                                        .font(Font.system(size: 12, weight: .light, design: .default))
                                }
                                .frame(width: 85, height: 85, alignment: .center)
                                .onTapGesture {
                                    self.selectedType = transactionType
                                    self.selectedtypeImageName = transactionType.presentingImageName
                                    self.selectedTypeCircleColor = transactionType.presentingColorName
                                    self.selectedTypeName = transactionType.presentingName
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            )
                            .frame(width: geo.size.width * 0.90, height: CGFloat(100 * (modula == 0 ? rowCounter : rowCounter + 1)), alignment: .center)
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .center)
                        
                    }
                    VStack {
                        
                    }
                    .frame(width: geo.size.width * 0.90, height: 100, alignment: .center)
                }
                .frame(width: geo.size.width * 0.90)
                .offset(x: geo.size.width / 16)
                
            }
        }
        .offset(y: 40)
        .frame(alignment: .top)
        .background(Color.gray)
        .ignoresSafeArea(.all, edges: [.bottom, .top])
        .foregroundColor(.white)
        .onAppear {
            self.subCategories = userSettingsVM.subCategories[self.categoty]!.sorted()
            print("subCategories: \(subCategories)")
            self.types = userSettingsVM.transactiontypesByCategoty[categoty]!
            print("types: \(types)")
        }
    }
}

struct CategotySelector_Previews: PreviewProvider {
    
    static var previews: some View {
        CategotySelector(categoty: Categories.Expense,
                         selectedType: .constant(TransactionType()),
                         selectedtypeImageName: .constant(""),
                         selectedTypeCircleColor: .constant(""),
                         selectedTypeName: .constant(""))
        
    }
}

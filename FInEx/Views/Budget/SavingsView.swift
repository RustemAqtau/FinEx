//
//  SavingsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct SavingsView: View {
    @EnvironmentObject var budgetVM: BudgetVM
    let geo: GeometryProxy
    @Environment(\.userSettingsVM) var userSettingsVM
    @Binding var savingsBySubCategory: [String : [Transaction]]
    @State var subCategories: [String] = []
    @State var savingsTotalAmountByCategory: [String : Decimal] = [:]
    var body: some View {
        let formatter = setDecimalFormatter()
        ScrollView {
            VStack {
                ForEach(self.subCategories, id: \.self) { subCategory in
                    VStack(alignment: .leading) {
                        HStack {
                            Group {
                                Text(subCategory)
                            }
                            Spacer()
                            Text("$" + formatter.string(from: NSDecimalNumber(decimal: savingsTotalAmountByCategory[subCategory] ?? 0))!)
                        }
                        .foregroundColor(.gray)
                        .frame(width: geo.size.width / 1.2 )
                        .scaledToFit()
                        .padding()
                        
                        Divider()
                        
                        ForEach(savingsBySubCategory[subCategory]!, id: \.date) { saving in
                            HStack {
                                Group {
                                    Image(systemName: saving.type!.presentingImageName)
                                        .foregroundColor(.white)
                                        .modifier(CircleModifier(color: Color(saving.type!.presentingColorName), strokeLineWidth: 3.0))
                                        .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                    VStack(alignment: .leading) {
                                        Text(saving.type!.presentingName)
                                            .shadow(radius: -10 )
                                        Text(setDate(date: saving.date!))
                                            .font(Font.system(size: 15, weight: .light, design: .default))
                                            .foregroundColor(.gray)
                                            
                                    }
                                }
                                
                                Spacer()
                                Text("$" + formatter.string(from: saving.amountDecimal)!)
                            }
                            .frame(width: geo.size.width / 1.15 )
                            .scaledToFit()
                            
                            Divider()
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                
            }
            .frame(width: geo.size.width)
            
            VStack {
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
            
        }
        .onAppear {
            for key in savingsBySubCategory.keys.sorted() {
                self.subCategories.append(key)
            }
            for subCategory in self.subCategories {
                var totalAmount: Decimal = 0
                for transaction in savingsBySubCategory[subCategory]! {
                    totalAmount += transaction.amount! as Decimal
                }
                savingsTotalAmountByCategory[subCategory] = totalAmount
            }
            
        }
    }

}

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            SavingsView(geo: geo, savingsBySubCategory: .constant([:]))
        }
        
    }
}

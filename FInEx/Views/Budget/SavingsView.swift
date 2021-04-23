//
//  SavingsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct SavingsView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    let geo: GeometryProxy
    @Environment(\.userSettingsVM) var userSettingsVM
    @Binding var savingsByType: [String: [TransactionType : Decimal]]
    @State var subCategories: [String] = []
    @State var typesInSubCategory: [String : [TransactionType]] = [:]
    
    @State var recurringTransactions: [RecurringTransaction] = []
    @Binding var addedRecurringTransaction: Bool
   
    var body: some View {
        let formatter = setDecimalFormatter()
        if let currentBudget = budgetVM.budgetList.last {
        ScrollView {
            VStack {
                if !self.recurringTransactions.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: currentBudget, recurringTransactions: self.recurringTransactions, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                
                ForEach(self.subCategories, id: \.self) { subCategory in
                    VStack(alignment: .leading) {
                        HStack {
                            Group {
                                Text(subCategory)
                            }
                            Spacer()
                        }
                        .foregroundColor(.gray)
                        .frame(width: geo.size.width / 1.2 )
                        .scaledToFit()
                        .padding()
                        
                        Divider()
                        
                        ForEach(typesInSubCategory[subCategory]!, id: \.self) { type in
                            HStack {
                                Group {
                                    Image(systemName: type.presentingImageName)
                                        .foregroundColor(.white)
                                        .modifier(CircleModifierSimpleColor(color: Color(type.presentingColorName), strokeLineWidth: 3.0))
                                        .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                        .animation(.linear(duration: 0.5))
                                        .transition(AnyTransition.opacity)
                                    VStack(alignment: .leading) {
                                        Text(type.presentingName)
                                            .shadow(radius: -10 )
                                            
                                    }
                                    .animation(.linear(duration: 0.5))
                                    .transition(AnyTransition.opacity)
                                }
                                
                                Spacer()
                                Text("$" + formatter.string(from: NSDecimalNumber(decimal: savingsByType[subCategory]![type] ?? 0) )!)
                                    .animation(.linear(duration: 0.5))
                                    .transition(AnyTransition.opacity)
                            }
                            .frame(width: geo.size.width / 1.15 )
                            .scaledToFit()
                            
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.white)
                
            }
            .frame(width: geo.size.width)
            
            VStack {
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
            
        }
        .onAppear {
            for key in savingsByType.keys.sorted() {
                self.subCategories.append(key)
                var arr: [TransactionType] = []
                for type in savingsByType[key]!.keys {
                    arr.append(type)
                }
                self.typesInSubCategory[key] = arr
            }
            
            
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Saving] ?? []
       }
        .onChange(of: currentBudget.savingsList.count, perform: { value in
            self.subCategories.removeAll()
            self.typesInSubCategory.removeAll()
            for key in savingsByType.keys.sorted() {
                self.subCategories.append(key)
                var arr: [TransactionType] = []
                for type in savingsByType[key]!.keys {
                    arr.append(type)
                }
                self.typesInSubCategory[key] = arr
            }
            
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Saving] ?? []
        })
        }
    }

}

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            SavingsView(geo: geo, savingsByType: .constant([:]), addedRecurringTransaction: .constant(false))
        }
        
    }
}

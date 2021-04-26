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
    
    @Binding var currentMonthBudget: MonthlyBudget
    
    @Binding var savingsTypesBySubCategory: [String : [TransactionType]]
    @Binding var savingsTotalAmountByType: [TransactionType : Decimal]
    
    @State var subCategories: [String] = []
    @State var typesInSubCategory: [String : [TransactionType]] = [:]
    
    @State var recurringTransactions: [RecurringTransaction] = []
    @Binding var addedRecurringTransaction: Bool
   
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!)
        ScrollView {
            VStack {
                if !self.recurringTransactions.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: self.currentMonthBudget, recurringTransactions: self.recurringTransactions, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                
                ForEach(self.savingsTypesBySubCategory.keys.sorted(), id: \.self) { subCategory in
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
                        
                        ForEach(savingsTypesBySubCategory[subCategory]!, id: \.self) { type in
                            HStack {
                                Group {
                                    Image(systemName: type.presentingImageName)
                                        .foregroundColor(.white)
                                        .modifier(CircleModifierSimpleColor(color: Color(type.presentingColorName), strokeLineWidth: 3.0))
                                        .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                        .animation(.linear(duration: 0.5))
                                        
                                    VStack(alignment: .leading) {
                                        Text(type.presentingName)
                                            .shadow(radius: -10 )
                                            
                                    }
                                    .animation(.linear(duration: 0.5))
                                }
                                Spacer()
                                Text(formatter.string(from: NSDecimalNumber(decimal: savingsTotalAmountByType[type] ?? 0) )!)
                                    .animation(.linear(duration: 0.5))
                                    
                            }
                            .frame(width: geo.size.width / 1.15 )
                            .scaledToFit()
                            
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                    .transition(.asymmetric(insertion: AnyTransition.opacity.combined(with: .slide), removal: .scale))
                }
                .background(Color.white)
                
            }
            .frame(width: geo.size.width)
            
            VStack {
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
            
        }
        .onAppear {
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentMonthBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Saving] ?? []
       }
        .onChange(of: currentMonthBudget.savingsList.count, perform: { value in
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentMonthBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Saving] ?? []
        })
        .onChange(of: self.typesInSubCategory, perform: { value in
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentMonthBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Saving] ?? []
        })
    }

}

//struct SavingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { geo in
//            SavingsView(geo: geo, savingsByType: .constant([:]), addedRecurringTransaction: .constant(false))
//        }
//        
//    }
//}

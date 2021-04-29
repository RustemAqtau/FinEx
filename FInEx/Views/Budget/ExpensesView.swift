//
//  ExpensesView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct ExpensesView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userSettingsVM) var userSettingsVM
    let geo: GeometryProxy
    @Binding var currentMonthBudget: MonthlyBudget
    
    @Binding var expensesBySubCategory: [String : [Transaction]]
    @Binding var expensesTotalAmountBySubCategory: [String : Decimal]
    @State var recurringTransactions: [RecurringTransaction] = []
    @Binding var addedRecurringTransaction: Bool
    @Binding var editTransaction: Bool
    @Binding var editingTransaction: Transaction
   
   
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!)
          //if let currentBudget = budgetVM.budgetList.last {
        ScrollView {
            VStack {
                if !self.recurringTransactions.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: self.currentMonthBudget, recurringTransactions: self.recurringTransactions, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                if !self.expensesBySubCategory.isEmpty {
                    ForEach(self.expensesBySubCategory.keys.sorted(), id: \.self) { subCategory in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .bottom) {
                                Group {
                                    Text(subCategory)
                                }
                                Spacer()
                                Text(formatter.string(from: NSDecimalNumber(decimal: expensesTotalAmountBySubCategory[subCategory] ?? 0))!)
                            }
                            .foregroundColor(CustomColors.TextDarkGray)
                            .frame(width: geo.size.width / 1.2 )
                            .font(Font.system(size: 18, weight: .light, design: .rounded))
                            .scaledToFit()
                            .padding()
                            Divider()
                                
                            ForEach(expensesBySubCategory[subCategory]!, id: \.date) { expense in
                                HStack {
                                    Group {
                                            if let expenseType = expense.type {
                                            Image(systemName: expenseType.presentingImageName)
                                                .foregroundColor(.white)
                                                .modifier(CircleModifierSimpleColor(color: Color(expenseType.presentingColorName), strokeLineWidth: 3.0))
                                                .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                                .font(Font.system(size: 24, weight: .regular, design: .default))
                                                .animation(.linear(duration: 0.5))
                                            VStack(alignment: .leading) {
                                                Text(expenseType.presentingName)
                                                    .shadow(radius: -10 )
                                                Text(setDate(date: expense.date!))
                                                    .font(Font.system(size: 15, weight: .light, design: .default))
                                                    .foregroundColor(.gray)
                                            }
                                            .animation(.linear(duration: 0.5))
                                            
                                        }
                                    }
                                    Spacer()
                                    Text(formatter.string(from: expense.amount ?? 0)!)
                                        .animation(.linear(duration: 0.5))
                                }
                                .frame(width: geo.size.width / 1.15 )
                                .scaledToFit()
                                .onTapGesture {
                                    self.editingTransaction = expense
                                    self.editTransaction = true
                                }
                                
                                Divider()
                            }
                            
                        }
                        .padding(.horizontal)
                        .transition(.asymmetric(insertion: AnyTransition.opacity.combined(with: .slide), removal: .scale))
                        
                    }
                    .background(Color.white)
                } else {
                    VStack {
                        Text("🤷")
                            .modifier(CircleModifier(color: GradientColors.TabBarBackground, strokeLineWidth: 2))
                            .font(Fonts.light40)
                            .frame(width: 90, height: 90, alignment: .center)
                        Text("There is no transactions for this month.")
                            .foregroundColor(.gray)
                            .font(Fonts.light15)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5, alignment: .center)
                }
                
                
            }
            .frame(width: geo.size.width)
            
            VStack {
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
        }
        .onAppear {
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentMonthBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Expense] ?? []
            
        }
        .onChange(of: self.currentMonthBudget.expensesList.count, perform: { value in
        
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentMonthBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Expense] ?? []

        })
        .onChange(of: self.expensesBySubCategory.count, perform: { value in
  
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentMonthBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Expense] ?? []
            
        })
        .sheet(isPresented: self.$editTransaction, content: {
            withAnimation(.easeInOut(duration: 2)) {
                EditTransactionView(transaction: self.$editingTransaction)
                    .environmentObject(self.budgetVM)
            }
        })
        
    }
   // }
    private func setDecimalZeroFractionFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.currencySymbol = userSettingsVM.settings.currencySymbol
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ""
        return formatter
    }
    
}

//struct ExpensesView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { geo in
//            ExpensesView(geo: geo, expensesBySubCategory: .constant([:]), addedRecurringTransaction: .constant(false) )
//        }
//        
//    }
//}


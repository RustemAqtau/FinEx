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
    @Binding var recurringTransactionsExpense: [RecurringTransaction]
    
    @Binding var addedRecurringTransaction: Bool
    @Binding var editTransaction: Bool
    @Binding var editingTransaction: Transaction
    @Binding var currencySymbol: String
    @Binding var showDecimals: Bool 
   
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: self.currencySymbol, fractionDigitsNumber: self.showDecimals ? 2 : 0)
          //if let currentBudget = budgetVM.budgetList.last {
        ScrollView {
            VStack(spacing: 15) {
                if !self.recurringTransactionsExpense.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: self.currentMonthBudget, recurringTransactions: self.recurringTransactionsExpense, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                if !self.expensesBySubCategory.isEmpty {
                    ForEach(self.expensesBySubCategory.keys.sorted(), id: \.self) { subCategory in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, alignment: .leading)
                            VStack(alignment: .leading, spacing: 5) {
                                HStack(alignment: .bottom) {
                                    Group {
                                        Text(LocalizedStringKey(subCategory))
                                    }
                                    Spacer()
                                    Text(formatter.string(from: NSDecimalNumber(decimal: expensesTotalAmountBySubCategory[subCategory] ?? 0))!)
                                }
                                .foregroundColor(CustomColors.TextDarkGray)
                                .frame(width: geo.size.width / 1.2, height: 35 )
                                .font(Font.system(size: 18, weight: .light, design: .default))
                                .scaledToFit()
                                .padding(.horizontal)
                                Divider()
                                    
                                ForEach(expensesBySubCategory[subCategory]!, id: \.self) { expense in
                                    HStack {
                                        Group {
                                                if let expenseType = expense.type {
                                                Image( expenseType.presentingImageName)
                                                    //Image("expense_Restaurant")
                                                    .foregroundColor(.white)
                                                        .font(Font.system(size: 15, weight: .regular, design: .default))
                                                    .modifier(CircleModifierSimpleColor(color: Color(expenseType.presentingColorName),
                                                                                        strokeLineWidth: 3.0))
                                                    .frame(width: 41, height: 41, alignment: .center)
                                                    .animation(.linear(duration: 0.5))
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text(LocalizedStringKey(expenseType.presentingName))
                                                            .shadow(radius: -10 )
                                                            //.font(Font.system(size: 18, weight: .light, design: .default))
                                                        Text(expense.notePresentation.isEmpty ? "" : "(\(expense.notePresentation))")
                                                            .font(Font.system(size: 13, weight: .ultraLight, design: .default))
                                                            
                                                        
                                                    }
                                                    //.foregroundColor(CustomColors.TextDarkGray)
                                                    Text(setDate(date: expense.date!))
                                                        .font(Font.system(size: 15, weight: .light, design: .default))
                                                        .foregroundColor(.gray)
                                                }
                                                //.animation(.linear(duration: 0.3))
                                                
                                            }
                                        }
                                        Spacer()
                                        Text(formatter.string(from: expense.amountDecimal)!)
                                            //.foregroundColor(CustomColors.TextDarkGray)
                                            //.animation(.linear(duration: 0.3))
                                    }
                                    //.animation(.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25))
                                    .animation(.linear(duration: 0.3))
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
                        
                        
                    }
                    .background(Color.white)
                } else {
                    NoDataPlaceholderView()
                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5, alignment: .center)
                }
                
                
            }
            .frame(width: geo.size.width)
            
            VStack {
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
        }
        .sheet(isPresented: self.$editTransaction, content: {
            withAnimation(.easeInOut(duration: 2)) {
                EditTransactionView(transaction: self.$editingTransaction, currencySymbol: self.$currencySymbol)
                    .environmentObject(self.budgetVM)
            }
        })
    }
}




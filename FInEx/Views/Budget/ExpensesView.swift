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
        let formatter = setDecimalFormatter()
          //if let currentBudget = budgetVM.budgetList.last {
        ScrollView {
            VStack {
                if !self.recurringTransactions.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: self.currentMonthBudget, recurringTransactions: self.recurringTransactions, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                
                ForEach(self.expensesBySubCategory.keys.sorted(), id: \.self) { subCategory in
                    VStack(alignment: .leading) {
                        HStack {
                            Group {
                                Text(subCategory)
                            }
                            Spacer()
                            Text("$" + formatter.string(from: NSDecimalNumber(decimal: expensesTotalAmountBySubCategory[subCategory] ?? 0))!)
                        }
                        .foregroundColor(CustomColors.TextDarkGray)
                        .frame(width: geo.size.width / 1.2 )
                        .font(Font.system(size: 18, weight: .light, design: .default))
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
                                           // .transition(AnyTransition.opacity)
                                        VStack(alignment: .leading) {
                                            Text(expenseType.presentingName)
                                                .shadow(radius: -10 )
                                            Text(setDate(date: expense.date!))
                                                .font(Font.system(size: 15, weight: .light, design: .default))
                                                .foregroundColor(.gray)
                                        }
                                        .animation(.linear(duration: 0.5))
                                        //.transition(AnyTransition.opacity)
                                        
                                    }
                                }
                                
                                
                                Spacer()
                                Text("$" + formatter.string(from: expense.amount ?? 0)!)
                                    .animation(.linear(duration: 0.5))
                                    //.transition(AnyTransition.opacity)
                            }
                            .frame(width: geo.size.width / 1.15 )
                            .scaledToFit()
                            .onTapGesture {
                                self.editingTransaction = expense
                                print(editingTransaction.amountDecimal)
                                self.editTransaction = true
                                
                            }
                            .sheet(isPresented: self.$editTransaction, content: {
                               
                                withAnimation(.easeInOut(duration: 2)) {
                                    EditTransactionView(transaction: self.$editingTransaction)
                                        .environmentObject(self.budgetVM)
                                }
                            })
                            Divider()
                        }
                        .onDelete(perform: {indexSet in withAnimation {  deleteTransaction(subCategory: subCategory, at: indexSet)} })
                        
                    }
                    .padding(.horizontal)
                    
                    
                }
                .background(Color.white)
                
                //.onDelete(perform: { indexSet in print(indexSet) })
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

        
    }
   // }
    func deleteTransaction(subCategory: String, at indexSet: IndexSet) {
        for index in indexSet {
            expensesBySubCategory[subCategory]![index].delete(context: viewContext)
        }
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


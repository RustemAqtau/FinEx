//
//  IncomeView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct IncomeView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userSettingsVM) var userSettingsVM
    let geo: GeometryProxy
    
    @Binding var currentMonthBudget: MonthlyBudget
    
    @Binding var incomeByType: [String: [Transaction]]
    @Binding var incomeTotalAmountByType: [String: Decimal]
    
    
    @State var dates: [String] = []
    @State var incomeTotalAmountByDate: [String : Decimal] = [:]
    @State var recurringTransactions: [RecurringTransaction] = []
    @Binding var addedRecurringTransaction: Bool
    @State var editTransaction: Bool = false
    @State var editingTransaction: Transaction = Transaction()
   
    var body: some View {
        let formatter = setDecimalFormatter()
       // if let currentBudget = budgetVM.budgetList.last {
        ScrollView {
            VStack {
                if !self.recurringTransactions.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: self.currentMonthBudget, recurringTransactions: self.recurringTransactions, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                
                ForEach(self.incomeByType.keys.sorted(), id: \.self) { type in
                    VStack(alignment: .leading) {
                        HStack {
                            Group {
                                Text(type)
                            }
                            Spacer()
                            Text("$" + formatter.string(from: NSDecimalNumber(decimal: incomeTotalAmountByType[type] ?? 0))! )
                        }
                        .foregroundColor(.gray)
                        .frame(width: geo.size.width / 1.2 )
                        .scaledToFit()
                        .padding()
                        Divider()
                        ForEach(self.incomeByType[type]!, id: \.date) { income in
                            HStack {
                                Group {
                                    if let incomeType = income.type {
                                        Image(systemName: incomeType.presentingImageName)
                                            .foregroundColor(.white)
                                            .modifier(CircleModifierSimpleColor(color: Color(incomeType.presentingColorName), strokeLineWidth: 3.0))
                                            .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                            .font(Font.system(size: 24, weight: .regular, design: .default))
                                            .animation(.linear(duration: 0.5))
                                            
                                        VStack(alignment: .leading) {
                                            Text(incomeType.presentingName)
                                                .shadow(radius: -10 )
                                             Text(setDate(date: income.date!))
                                                .font(Font.system(size: 15, weight: .light, design: .default))
                                                .foregroundColor(.gray)
                                        }
                                        .animation(.linear(duration: 0.5))
                                    }
                                }
                               Spacer()
                                Text("$" + formatter.string(from: income.amountDecimal)!)
                                    .animation(.linear(duration: 0.5))
                            }
                            .frame(width: geo.size.width / 1.15 )
                            .scaledToFit()
                            .onTapGesture {
                                self.editingTransaction = income
                                self.editTransaction = true
                            }
                            .sheet(isPresented: self.$editTransaction, content: {
                               withAnimation(.easeInOut(duration: 2)) {
                                    EditTransactionView(transaction: self.$editingTransaction)
                                }
                            })
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
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Income] ?? []
        }
        .onChange(of: currentMonthBudget.incomeList.count, perform: { value in
           
            
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentMonthBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Income] ?? []
        })
       // }
    }
}

//struct IncomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { geo in
//            IncomeView(geo: geo, incomeByDate: .constant([:]), addedRecurringTransaction: .constant(false) )
//        }
//        
//    }
//}

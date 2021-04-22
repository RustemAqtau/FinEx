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
    @Binding var incomeByDate: [String : [Transaction]]
    @State var dates: [String] = []
    @State var incomeTotalAmountByDate: [String : Decimal] = [:]
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
                
                ForEach(self.dates, id: \.self) { date in
                    VStack(alignment: .leading) {
                        HStack {
                            Group {
                                Text(date)
                            }
                            Spacer()
                            Text("$" + formatter.string(from: NSDecimalNumber(decimal: incomeTotalAmountByDate[date] ?? 0))! )
                        }
                        .foregroundColor(.gray)
                        .frame(width: geo.size.width / 1.2 )
                        .scaledToFit()
                        .padding()
                        
                        Divider()
                        
                        ForEach(incomeByDate[date]!, id: \.date) { income in
                            HStack {
                                Group {
                                    Image(systemName: income.type!.presentingImageName)
                                        .foregroundColor(.white)
                                        .modifier(CircleModifierSimpleColor(color: Color(income.type!.presentingColorName), strokeLineWidth: 3.0))
                                        .frame(width: geo.size.width / 9, height: geo.size.width / 9, alignment: .center)
                                        .font(Font.system(size: 24, weight: .regular, design: .default))
                                        .animation(.linear(duration: 0.5))
                                        .transition(AnyTransition.opacity)
                                    VStack(alignment: .leading) {
                                        Text(income.type!.presentingName)
                                            .shadow(radius: -10 )
                                        Text(setDate(date: income.date!))
                                            .font(Font.system(size: 15, weight: .light, design: .default))
                                            .foregroundColor(.gray)
                                            
                                    }
                                    .animation(.linear(duration: 0.5))
                                    .transition(AnyTransition.opacity)
                                }
                                
                                Spacer()
                                Text("$" + formatter.string(from: income.amountDecimal)!)
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
            for key in incomeByDate.keys.sorted(by: >) {
                self.dates.append(key)
            }
            for date in self.dates {
                var totalAmount: Decimal = 0
                for transaction in incomeByDate[date]! {
                    totalAmount += transaction.amount! as Decimal
                }
                incomeTotalAmountByDate[date] = totalAmount
            }
            
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Income] ?? []
        }
        .onChange(of: currentBudget.incomeList.count, perform: { value in
            self.dates.removeAll()
            self.incomeTotalAmountByDate.removeAll()
            for key in incomeByDate.keys.sorted(by: >) {
                self.dates.append(key)
            }
            for date in self.dates {
                var totalAmount: Decimal = 0
                for transaction in incomeByDate[date]! {
                    totalAmount += transaction.amount! as Decimal
                }
                incomeTotalAmountByDate[date] = totalAmount
            }
            
            userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: currentBudget, context: viewContext)
            self.recurringTransactions = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Income] ?? []
        })
        }
    }
}

struct IncomeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            IncomeView(geo: geo, incomeByDate: .constant([:]), addedRecurringTransaction: .constant(false) )
        }
        
    }
}

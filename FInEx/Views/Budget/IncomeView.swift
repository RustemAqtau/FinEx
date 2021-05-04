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
    @Binding var recurringTransactionsIncome: [RecurringTransaction]
    
    @State var dates: [String] = []
    @State var incomeTotalAmountByDate: [String : Decimal] = [:]
    @Binding var addedRecurringTransaction: Bool
    @State var editTransaction: Bool = false
    @State var editingTransaction: Transaction = Transaction()
   
    var body: some View {
        let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!, fractionDigitsNumber: self.userSettingsVM.settings.showDecimals ? 2 : 0)
        ScrollView {
            VStack(spacing: 15) {
                if !self.recurringTransactionsIncome.isEmpty {
                    AddRecurringTransactionView(geo: geo, currentBudget: self.currentMonthBudget, recurringTransactions: self.recurringTransactionsIncome, addedRecurringTransaction: self.$addedRecurringTransaction)
                        .environmentObject(budgetVM)
                }
                if !self.incomeByType.isEmpty {
                    ForEach(self.incomeByType.keys.sorted(), id: \.self) { type in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, alignment: .leading)
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Group {
                                        Text(type)
                                    }
                                    Spacer()
                                    Text(formatter.string(from: NSDecimalNumber(decimal: incomeTotalAmountByType[type] ?? 0))! )
                                }
                                .foregroundColor(CustomColors.TextDarkGray)
                                .frame(width: geo.size.width / 1.2 )
                                .font(Font.system(size: 18, weight: .light, design: .rounded))
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
                                                    .frame(width: geo.size.width * 0.10, height: geo.size.width * 0.10, alignment: .center)
                                                    .font(Font.system(size: 20, weight: .regular, design: .default))
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
                                        Text(formatter.string(from: income.amountDecimal)!)
                                            .animation(.linear(duration: 0.5))
                                    }
                                    
                                    .frame(width: geo.size.width / 1.15 )
                                    .scaledToFit()
                                    
                                    .onTapGesture {
                                        self.editingTransaction = income
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
                EditTransactionView(transaction: self.$editingTransaction)
            }
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

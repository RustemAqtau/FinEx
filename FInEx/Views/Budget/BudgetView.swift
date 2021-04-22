//
//  BudgetView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var currentMonthBudget: MonthlyBudget
    @State var presentingTransactions: [Transaction] = []
    let geo: GeometryProxy
    @State var offsetY: CGFloat = 0.0
    @State var incomeSelected = false
    @State var savingsSelected = false
    @Binding var plusButtonColor: LinearGradient
    @Binding var plusButtonIsServing: String
    @State var expensesBySubCategory: [String: [Transaction]] = [:]
    @State var incomeByDate: [String: [Transaction]] = [:]
    @State var savingsByType: [String: [TransactionType : Decimal]] = [:]
    @State var addedRecurringTransaction: Bool = false
    
    var body: some View {
        let formatter = setDecimalFormatter()
        if let currentBudget = budgetVM.budgetList.last {
        VStack {
            VStack(spacing: 0) {
                
                Text("BUDGET")
                    .foregroundColor(.gray)
                HStack(spacing: -10) {
                    
                        VStack {
                            Text(formatter.string(from: currentBudget.totalIncome)!)
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: self.incomeSelected ? 20 : 16, weight: .light, design: .default))
                            Text("INCOME")
                                .font(.footnote)
                                .opacity(0.8)
                        }
                        .modifier(CircleModifier(color: GradientColors.Income, strokeLineWidth: self.incomeSelected ? 4.5 : 3.0))
                        .frame(width: self.incomeSelected ? geo.size.width / 2.5 :  geo.size.width / 4.2, height: 110, alignment: .center)
                        .padding()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if self.savingsSelected {
                                    self.savingsSelected.toggle()
                                }
                                self.incomeSelected = true
                                self.plusButtonColor = GradientColors.Income
                                self.plusButtonIsServing = Categories.Income
                                
                            }
                        }
                        
                        Divider()
                        VStack {
                            Text(formatter.string(from: currentBudget.totalExpenses)!)
                                .font(Font.system(size: (self.savingsSelected || self.incomeSelected) ? 16 : 20, weight: .light, design: .default))
                            Text("EXPENSES")
                                .font(.footnote)
                                .opacity(0.8)
                        }
                        .modifier(CircleModifier(color: GradientColors.Expense, strokeLineWidth: (self.savingsSelected || self.incomeSelected) ? 3.0 : 4.5))
                        .frame(width: (self.savingsSelected || self.incomeSelected) ? geo.size.width / 4.2 :  geo.size.width / 2.5, height: 110, alignment: .center)
                        .padding()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if self.incomeSelected {
                                    self.incomeSelected.toggle()
                                }
                                if self.savingsSelected {
                                    self.savingsSelected.toggle()
                                }
                                self.plusButtonColor = GradientColors.Expense
                                self.plusButtonIsServing = Categories.Expense
                            }
                        }
                        Divider()
                        VStack {
                            Text(formatter.string(from: currentBudget.totalSavings)!)
                                .font(Font.system(size: self.savingsSelected ? 20 : 16, weight: .light, design: .default))
                            Text("SAVINGS")
                                .font(.footnote)
                                .opacity(0.8)
                        }
                        .modifier(CircleModifier(color: GradientColors.Saving, strokeLineWidth: self.savingsSelected ? 4.5 : 3.0))
                        .frame(width: self.savingsSelected ? geo.size.width / 2.5 :  geo.size.width / 4.2, height: 110, alignment: .center)
                        .padding()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if self.incomeSelected {
                                    self.incomeSelected.toggle()
                                }
                                self.savingsSelected = true
                                self.plusButtonColor = GradientColors.Saving
                                self.plusButtonIsServing = Categories.Saving
                            }
                        }
                }
                .frame(width: geo.size.width, height: 100
                       , alignment: .center)
                .offset(x: 0, y: offsetY)
                .onAppear {
                    startAnimate()
                }
                
            }
            .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
            .background(LinearGradient(gradient: Gradient(colors: [Color("TopGradient"), Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
            .foregroundColor(.white)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 0.5)
                    .shadow(radius: 10)
                    .foregroundColor(.gray)
                    .frame(width: geo.size.width / 2, height: 40, alignment: .center)
                Text("\(currentBudget.monthYearStringPresentation)")
                    .font(Font.system(size: 20, weight: .light, design: .default))
                    .foregroundColor(.black)
            }
            .background(Color.white)
            
            if self.incomeSelected {
                IncomeView(geo: geo, incomeByDate: self.$incomeByDate, addedRecurringTransaction: self.$addedRecurringTransaction)
                    .environmentObject(self.budgetVM)
            } else if self.savingsSelected {
                SavingsView(geo: geo, savingsByType: self.$savingsByType, addedRecurringTransaction: self.$addedRecurringTransaction)
                    .environmentObject(self.budgetVM)
            } else {
                ExpensesView(geo: geo, expensesBySubCategory: self.$expensesBySubCategory, addedRecurringTransaction: self.$addedRecurringTransaction)
                    .environmentObject(self.budgetVM)
            }
        }
        .background(Color.white)
        .onAppear {
            self.presentingTransactions = currentMonthBudget.expensesList
            self.expensesBySubCategory = currentBudget.expensesBySubCategory
            self.incomeByDate = currentBudget.incomeByDate
            self.savingsByType = currentBudget.savingsByType
        }
        .onChange(of: currentBudget.transactions?.count, perform: { value in
            self.expensesBySubCategory = currentBudget.expensesBySubCategory
            self.incomeByDate = currentBudget.incomeByDate
            self.savingsByType = currentBudget.savingsByType
        })
        .onChange(of: self.addedRecurringTransaction, perform: { value in
            self.expensesBySubCategory = currentBudget.expensesBySubCategory
            self.incomeByDate = currentBudget.incomeByDate
            self.savingsByType = currentBudget.savingsByType
        })
        
        }
    }
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 20.0
        }
    }
    
    private func setDecimalZeroFractionFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ""
        return formatter
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader {
                geo in
                BudgetView(currentMonthBudget: .constant(MonthlyBudget()) , geo: geo, plusButtonColor: .constant(GradientColors.Expense), plusButtonIsServing: .constant(""))
            }
            
            GeometryReader {
                geo in
                BudgetView(currentMonthBudget: .constant(MonthlyBudget()), geo: geo, plusButtonColor: .constant(GradientColors.Expense), plusButtonIsServing: .constant(""))
            }
            .preferredColorScheme(.dark)
        }
        
    }
}

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
    @State var expensesTotalAmountBySubCategory: [String : Decimal] = [:]
    
    @State var incomeByType: [String: [Transaction]] = [:]
    @State var incomeTotalAmountByType: [String: Decimal] = [:]
    
    @State var savingsByType: [String: [TransactionType : Decimal]] = [:]
    
    @State var addedRecurringTransaction: Bool = false
    
    @State var editTransaction: Bool = false
    @State var editingTransaction: Transaction = Transaction()
   
    @Binding var getPreviousMonthBudget: Bool
    @Binding var getNextMonthBudget: Bool
    var body: some View {
        NavigationView {
            let formatter = setDecimalFormatter()
            //if let currentBudget = budgetVM.budgetList.last {
                
                VStack {
                    VStack(spacing: 0) {
                        
                        HStack(spacing: -10) {
                            
                            VStack {
                                Text(formatter.string(from: currentMonthBudget.totalIncome)!)
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: self.incomeSelected ? 20 : 16, weight: .light, design: .default))
                                Text("INCOME")
                                    .font(.footnote)
                                    .opacity(0.8)
                            }
                            .modifier(RoundedRectangleModifier(color: GradientColors.Income, strokeLineWidth: self.incomeSelected ? 4.5 : 3.0))
                            .frame(width: self.incomeSelected ? geo.size.width / 2.5 :  geo.size.width / 4.2, height: 70, alignment: .center)
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
                                Text(formatter.string(from: currentMonthBudget.totalExpenses)!)
                                    .font(Font.system(size: (self.savingsSelected || self.incomeSelected) ? 16 : 20, weight: .light, design: .default))
                                    .multilineTextAlignment(.center)
                                Text("EXPENSES")
                                    .font(.footnote)
                                    .opacity(0.8)
                            }
                            .modifier(RoundedRectangleModifier(color: GradientColors.Expense, strokeLineWidth: (self.savingsSelected || self.incomeSelected) ? 3.0 : 4.5))
                            .frame(width: (self.savingsSelected || self.incomeSelected) ? geo.size.width / 4.2 :  geo.size.width / 2.5, height: 70, alignment: .center)
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
                                Text(formatter.string(from: currentMonthBudget.totalSavings)!)
                                    .font(Font.system(size: self.savingsSelected ? 20 : 16, weight: .light, design: .default))
                                    .multilineTextAlignment(.center)
                                Text("SAVINGS")
                                    .font(.footnote)
                                    .opacity(0.8)
                            }
                            .modifier(RoundedRectangleModifier(color: GradientColors.Saving, strokeLineWidth: self.savingsSelected ? 4.5 : 3.0))
                            .frame(width: self.savingsSelected ? geo.size.width / 2.5 :  geo.size.width / 4.2, height: 70, alignment: .center)
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
                        .frame(width: geo.size.width, height: 70
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
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 0.5)
                            .shadow(radius: 10)
                            .foregroundColor(.gray)
                            .frame(width: geo.size.width * 0.70, height: 45, alignment: .center)
                        HStack(spacing: 20) {
                            Button(action: {
                                
                                self.getPreviousMonthBudget.toggle()
                            }) {
                                Image(systemName: Icons.ChevronCompactLeft)
                            }
                            Spacer()
                            Text("\(currentMonthBudget.monthYearStringPresentation)")
                            Spacer()
                            Button(action: {
                                
                                self.getNextMonthBudget.toggle()
                            }) {
                                Image(systemName: Icons.ChevronCompactRight)
                            }
                                
                        }
                        .font(Font.system(size: 20, weight: .light, design: .default))
                        .foregroundColor(.black)
                        .frame(width: geo.size.width * 0.65)
                        .padding()
                    }
                    .background(Color.white)
                    
                    if self.incomeSelected {
                        IncomeView(geo: geo,
                                   currentMonthBudget: self.$currentMonthBudget,
                                   incomeByType: self.$incomeByType,
                                   incomeTotalAmountByType: self.$incomeTotalAmountByType,
                                   addedRecurringTransaction: self.$addedRecurringTransaction)
                            .environmentObject(self.budgetVM)
                    } else if self.savingsSelected {
                        SavingsView(geo: geo,
                                    currentMonthBudget: self.$currentMonthBudget,
                                    savingsByType: self.$savingsByType,
                                    addedRecurringTransaction: self.$addedRecurringTransaction)
                            .environmentObject(self.budgetVM)
                    } else {
                        ExpensesView(geo: geo,
                                     currentMonthBudget: self.$currentMonthBudget,
                                     expensesBySubCategory: self.$expensesBySubCategory,
                                     expensesTotalAmountBySubCategory: self.$expensesTotalAmountBySubCategory,
                                     addedRecurringTransaction: self.$addedRecurringTransaction,
                                     editTransaction: self.$editTransaction,
                                     editingTransaction: self.$editingTransaction)
                            .environmentObject(self.budgetVM)
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
                .navigationBarTitle (Text("BUDGET"), displayMode: .inline)
                .background(Color.white)
                .onAppear {
                    self.presentingTransactions = currentMonthBudget.expensesList
                    updateData()
                }
                .onChange(of: self.budgetVM.transactionList.count, perform: { value in
                    updateData()
                })
                .onChange(of: self.addedRecurringTransaction, perform: { value in
                    updateData()
                })
                .onChange(of: self.editTransaction, perform: { value in
                    updateData()
                })
                .onChange(of: self.getPreviousMonthBudget, perform: { value in
                    updateData()
                })
                .onChange(of: self.getNextMonthBudget, perform: { value in
                    updateData()
                })
           }
        //}
    }
    func updateData() {
        self.expensesBySubCategory = self.currentMonthBudget.expensesBySubCategory
        self.expensesTotalAmountBySubCategory = self.currentMonthBudget.expensesTotalAmountBySubCategory
        self.incomeByType = self.currentMonthBudget.incomeByType
        self.incomeTotalAmountByType = self.currentMonthBudget.incomeTotalAmountByType
        self.savingsByType = self.currentMonthBudget.savingsByType
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

//struct BudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            GeometryReader {
//                geo in
//                BudgetView(currentMonthBudget: .constant(MonthlyBudget()) , geo: geo, plusButtonColor: .constant(GradientColors.Expense), plusButtonIsServing: .constant(""))
//            }
//            
//            GeometryReader {
//                geo in
//                BudgetView(currentMonthBudget: .constant(MonthlyBudget()), geo: geo, plusButtonColor: .constant(GradientColors.Expense), plusButtonIsServing: .constant(""))
//            }
//            .preferredColorScheme(.dark)
//        }
//        
//    }
//}

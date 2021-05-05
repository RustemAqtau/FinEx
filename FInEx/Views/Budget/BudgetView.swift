//
//  BudgetView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI

struct BudgetView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var currentMonthBudget: MonthlyBudget
    @State var presentingTransactions: [Transaction] = []
    let geo: GeometryProxy
    @State var offsetY: CGFloat = 0.0
    @State var incomeSelected = false
    @State var savingsSelected = false
    @Binding var plusButtonColor: LinearGradient
    @Binding var plusButtonIsServing: String
    @Binding var coloredNavAppearance: UINavigationBarAppearance
    @Binding var themeColor: LinearGradient
    
    @State var expensesBySubCategory: [String: [Transaction]] = [:]
    @State var expensesTotalAmountBySubCategory: [String : Decimal] = [:]
    @State var recurringTransactionsExpense: [RecurringTransaction] = []
    
    @State var incomeByType: [String: [Transaction]] = [:]
    @State var incomeTotalAmountByType: [String: Decimal] = [:]
    @State var recurringTransactionsIncome: [RecurringTransaction] = []
    
    @State var savingsTypesBySubCategory: [String : [TransactionType]] = [:]
    @State var savingsTotalAmountByType: [TransactionType : Decimal] = [:]
    @State var currentMonthSavingsByType: [TransactionType : [Transaction]] = [:]
    @State var recurringTransactionsSaving: [RecurringTransaction] = []
    
    @State var addedRecurringTransaction: Bool = false
    
    @State var editTransaction: Bool = false
    @State var editingTransaction: Transaction = Transaction()
    
    @Binding var getPreviousMonthBudget: Bool
    @Binding var getNextMonthBudget: Bool
    @Binding var hideLeftChevron: Bool
    @Binding var hideRightChevron: Bool
    
    @Binding var showAddTransaction: Bool
    @Binding var askPasscode: Bool
    
    var body: some View {
        NavigationView {
            let formatter = setDecimalFormatter(currencySymbol: userSettingsVM.settings.currencySymbol!, fractionDigitsNumber: self.userSettingsVM.settings.showDecimals ? 2 : 0)
            GeometryReader { geo in
                VStack {
                }
                .frame(width: geo.size.width, height: geo.size.height / 3, alignment: .center)
                .background(themeColor)
                .ignoresSafeArea(.all, edges: .top)
                //.navigationBarTitle (Text(LocalizedStringKey("ANALYTICS")), displayMode: .inline)
                
                VStack {
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text(LocalizedStringKey("BALANCE"))
                            Text(formatter.string(from: NSDecimalNumber(decimal: currentMonthBudget.currentBalance))!)
                        }
                       .frame(width: geo.size.width * 0.90, height: 20, alignment: .center)
                        //.offset(y: 50)
                        .foregroundColor(CustomColors.TextDarkGray)
                        .opacity(0.8)
                        .font(Fonts.light15)
                        //.background(GradientColors.TopBackground)
                        HStack(spacing: -10) {
                            VStack {
                                Text(formatter.string(from: currentMonthBudget.totalIncome)!)
                                    .multilineTextAlignment(.center)
                                    .font(Font.system(size: self.incomeSelected ? 20 : 16, weight: .light, design: .default))
                                Text(LocalizedStringKey("INCOME"))
                                    //.font(.footnote)
                                    .font(Fonts.light12)
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
                                Text(LocalizedStringKey("EXPENSES"))
                                   // .font(.footnote)
                                    .font(Fonts.light12)
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
                                Text(LocalizedStringKey("SAVINGS"))
                                    //.font(.footnote)
                                    .font(Fonts.light12)
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
                        .frame(width: geo.size.width, height: 90, alignment: .center)
                        
                       // .border(Color.black)
                        //.offset(x: 0, y: offsetY)
                        .offset(x: 0, y: 10.0)
//                        .onAppear {
//                            startAnimate()
//
//                        }
                        
                    }
                   .frame(width: geo.size.width, height: geo.size.height / 6, alignment: .center)
                    //.background(themeColor)
                    .sheet(isPresented: self.$showAddTransaction, content: {
                        let addingCategory = getAddingCategory()
                        AddTransactionView(currentMonthBudget: self.$currentMonthBudget, category:addingCategory)
                            .environmentObject(self.budgetVM)
                            .environment(\.userSettingsVM, self.userSettingsVM)
                    })
                    .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            //withAnimation(.linear(duration: 1)) {
                                self.getPreviousMonthBudget.toggle()
                           // }
                        }) {
                            Image(systemName: Icons.ChevronCompactLeft)
                        }
                        .opacity(self.hideLeftChevron ? 0 : 1)
                        Spacer()
                        Text("\(currentMonthBudget.monthYearStringPresentation)")
                        Spacer()
                        Button(action: {
                            //withAnimation(.linear(duration: 1)) {
                                self.getNextMonthBudget.toggle()
                           // }
                        }) {
                            Image(systemName: Icons.ChevronCompactRight)
                        }
                        .opacity(self.hideRightChevron ? 0 : 1)
                        
                    }
                    .padding(.horizontal)
                    .font(Font.system(size: 20, weight: .light, design: .default))
                    .foregroundColor(.black)
                    .modifier(RoundedRectangleModifierSimpleColor(color: Color.white, strokeLineWidth: 3))
                    .frame(width: geo.size.width * 0.90, height: 50)
                    
                    
                    if self.incomeSelected {
                        IncomeView(geo: geo,
                                   currentMonthBudget: self.$currentMonthBudget,
                                   incomeByType: self.$incomeByType,
                                   incomeTotalAmountByType: self.$incomeTotalAmountByType,
                                   recurringTransactionsIncome: self.$recurringTransactionsIncome,
                                   addedRecurringTransaction: self.$addedRecurringTransaction)
                            .environmentObject(self.budgetVM)
                    } else if self.savingsSelected {
                        SavingsView(geo: geo,
                                    currentMonthBudget: self.$currentMonthBudget,
                                    savingsTypesBySubCategory: self.$savingsTypesBySubCategory,
                                    savingsTotalAmountByType: self.$savingsTotalAmountByType,
                                    currentMonthSavingsByType: self.$currentMonthSavingsByType,
                                    recurringTransactionsSaving: self.$recurringTransactionsSaving,
                                    addedRecurringTransaction: self.$addedRecurringTransaction)
                            .environmentObject(self.budgetVM)
                    } else {
                        ExpensesView(geo: geo,
                                     currentMonthBudget: self.$currentMonthBudget,
                                     expensesBySubCategory: self.$expensesBySubCategory,
                                     expensesTotalAmountBySubCategory: self.$expensesTotalAmountBySubCategory,
                                     recurringTransactionsExpense: self.$recurringTransactionsExpense,
                                     addedRecurringTransaction: self.$addedRecurringTransaction,
                                     editTransaction: self.$editTransaction,
                                     editingTransaction: self.$editingTransaction)
                            .environmentObject(self.budgetVM)
                    }
                }
                
              //  .ignoresSafeArea(.all, edges: .top)
                .navigationBarTitle (Text(LocalizedStringKey("BUDGET")), displayMode: .inline)
                //.background(GradientColors.TopBackground)
               // .transition(.asymmetric(insertion: AnyTransition.opacity.combined(with: .slide), removal: .scale))
               // .background(GradientColors.TabBarBackground) //(CustomColors.TopBackgroundGradient3)
                .onAppear {
                    self.currentMonthBudget = budgetVM.budgetList.last!
                    self.presentingTransactions = currentMonthBudget.expensesList
                    updateData()
                    //coloredNavAppearance.backgroundColor = colorScheme == .dark ? UIColor(CustomColors.White_Background) : UIColor.clear
                    UINavigationBar.appearance().standardAppearance = coloredNavAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
                    
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
                .onChange(of: self.addedRecurringTransaction, perform: { value in
                    updateData()
                })
                .onChange(of: self.askPasscode, perform: { value in
                    updateData()
                })
            }
            .background(CustomColors.White_Background)
            
//            .onChange(of: self.askPasscode, perform: { value in
//                updateData()
//            })
            
        }
        
    }
    func updateData() {
        self.expensesBySubCategory = self.currentMonthBudget.expensesBySubCategory
        self.expensesTotalAmountBySubCategory = self.currentMonthBudget.expensesTotalAmountBySubCategory
        self.incomeByType = self.currentMonthBudget.incomeByType
        self.incomeTotalAmountByType = self.currentMonthBudget.incomeTotalAmountByType
        self.savingsTypesBySubCategory = self.currentMonthBudget.savingsTypesBySubCategory
        self.savingsTotalAmountByType = self.currentMonthBudget.savingsTotalAmountByType
        self.currentMonthSavingsByType = self.currentMonthBudget.currentMonthSavingsByType
        userSettingsVM.getRecurringTransactionsByCategory(monthlyBudget: self.currentMonthBudget, context: viewContext)
        self.recurringTransactionsExpense = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Expense] ?? []
        self.recurringTransactionsIncome = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Income] ?? []
        self.recurringTransactionsSaving = userSettingsVM.recurringTransactionsByCategoryForBudget[Categories.Saving] ?? []
    }
    
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 10.0
        }
    }
    
    private func setDecimalZeroFractionFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.currencySymbol = userSettingsVM.settings.currencySymbol
        formatter.maximumFractionDigits = userSettingsVM.settings.showDecimals ? 2 : 0
        formatter.groupingSeparator = ""
        return formatter
    }
    
    private func getAddingCategory() -> String {
        var addingCategory: String = ""
        switch self.plusButtonIsServing {
        case Categories.Expense:
            addingCategory = Categories.Expense
        case Categories.Income:
            addingCategory = Categories.Income
        case Categories.Saving:
            addingCategory = Categories.Saving
        default:
            addingCategory = Categories.Expense
        }
        return addingCategory
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

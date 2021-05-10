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
    @State var currencySymbol: String = ""
    @State var showDecimals: Bool = false
    
    @Binding var getPreviousMonthBudget: Bool
    @Binding var getNextMonthBudget: Bool
    @Binding var hideLeftChevron: Bool
    @Binding var hideRightChevron: Bool
    
    @Binding var showAddTransaction: Bool
    @Binding var askPasscode: Bool
    
    @State var sendingDataURL: URL = URL(fileURLWithPath: "")
    
    var body: some View {
        NavigationView {
            let formatter = setDecimalFormatter(currencySymbol: self.currencySymbol, fractionDigitsNumber: self.showDecimals ? 2 : 0)
            GeometryReader { geo in
                VStack {
                }
                .frame(width: geo.size.width, height: geo.size.height / 3, alignment: .center)
                .background(themeColor)
                .ignoresSafeArea(.all, edges: .top)
                
                VStack {
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 15) {
                            HStack(spacing: 5) {
                                Text(LocalizedStringKey("BALANCE"))
                                Text(formatter.string(from: NSDecimalNumber(decimal: currentMonthBudget.currentBalance))!)
                            }
                            
                            .onAppear {
                                startAnimate()
                            }
                        }
                       .frame(width: geo.size.width * 0.90, height: 20, alignment: .center)
                        //.offset(y: 50)
                        .foregroundColor(CustomColors.TextDarkGray)
                        .opacity(0.8)
                        .font(Fonts.light15)
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
                        .offset(x: 0, y: offsetY)
                        .onAppear {
                            startAnimate()

                        }
                    }
                   .frame(width: geo.size.width, height: geo.size.height / 6, alignment: .center)
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
                                   addedRecurringTransaction: self.$addedRecurringTransaction,
                                   currencySymbol: self.$currencySymbol,
                                   showDecimals: self.$showDecimals )
                            .environmentObject(self.budgetVM)
                    } else if self.savingsSelected {
                        SavingsView(geo: geo,
                                    currentMonthBudget: self.$currentMonthBudget,
                                    savingsTypesBySubCategory: self.$savingsTypesBySubCategory,
                                    savingsTotalAmountByType: self.$savingsTotalAmountByType,
                                    currentMonthSavingsByType: self.$currentMonthSavingsByType,
                                    recurringTransactionsSaving: self.$recurringTransactionsSaving,
                                    addedRecurringTransaction: self.$addedRecurringTransaction,
                                    currencySymbol: self.$currencySymbol,
                                    showDecimals: self.$showDecimals)
                            .environmentObject(self.budgetVM)
                    } else {
                        ExpensesView(geo: geo,
                                     currentMonthBudget: self.$currentMonthBudget,
                                     expensesBySubCategory: self.$expensesBySubCategory,
                                     expensesTotalAmountBySubCategory: self.$expensesTotalAmountBySubCategory,
                                     recurringTransactionsExpense: self.$recurringTransactionsExpense,
                                     addedRecurringTransaction: self.$addedRecurringTransaction,
                                     editTransaction: self.$editTransaction,
                                     editingTransaction: self.$editingTransaction,
                                     currencySymbol: self.$currencySymbol,
                                     showDecimals: self.$showDecimals)
                            .environmentObject(self.budgetVM)
                    }
                }
                
                .navigationBarTitle (Text(LocalizedStringKey("BUDGET")), displayMode: .inline)
                .navigationBarItems(
                    
//                    leading: Button(action: {
//                    for budget in self.budgetVM.budgetList {
//                        viewContext.delete(budget)
//                        if viewContext.hasChanges {
//                            do {
//                                try viewContext.save()
//                                print("Transaction deleted")
//                            } catch {
//                                print("Could not save context")
//                            }
//                        }
//                    }
//                }) {
//                    VStack(spacing: 0){
//
//                        Text("Remove All")
//                            .font(Fonts.light10)
//                    }
//                },
                    trailing:
                                        Button(action: {
                                            let shareManager = CSVShareManager()
                                            let csvData = shareManager.createMonthBudgetCSV(for: currentMonthBudget)
                                            let path = try? FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                                            sendingDataURL = path!.appendingPathComponent("FInEx-\(currentMonthBudget.monthYearStringPresentation).csv")
                                            try?csvData.write(to: sendingDataURL)
                                            shareManager.shareCSV(url: sendingDataURL)
                                        }) {
                                            VStack(spacing: 0){
                                                Image(systemName: Icons.Doc_Arrow_Down)
                                                Text("CSV")
                                                    .font(Fonts.light10)
                                            }
                                        }
                )
                .onAppear {
                    self.currentMonthBudget = budgetVM.budgetList.last!
                    updateData()
                    self.currencySymbol = userSettingsVM.settings.currencySymbol ?? ""
                    self.showDecimals = userSettingsVM.settings.showDecimals
                    UINavigationBar.appearance().standardAppearance = coloredNavAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
                    
                }
                .onChange(of: self.budgetVM.transactionList.count, perform: { value in
                    updateData()
                })
                .onChange(of: self.budgetVM.transactionEdited, perform: { value in
                    updateData()
                })
                .onChange(of: self.addedRecurringTransaction, perform: { value in
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
            

            
        }
        .accentColor(CustomColors.TextDarkGray)
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



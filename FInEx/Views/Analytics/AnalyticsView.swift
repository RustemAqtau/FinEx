//
//  AnalyticsView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-07.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var coloredNavAppearance: UINavigationBarAppearance
    @Binding var currentMonthBudget: MonthlyBudget
    @State var sendingDataURL: URL = URL(fileURLWithPath: "")
    @State var offsetY: CGFloat = 0.0
    
    @State var entriesForExpenses: [PieChartDataEntry] = []
    @State var entriesForIncome: [PieChartDataEntry] = []
    @State var entriesForSaving: [PieChartDataEntry] = []
    
    @State var entriesBarChartExpenses: [BarChartDataEntry] = []
    @State var entriesBarChartIncome: [BarChartDataEntry] = []
    @State var entriesBarChartSaving: [BarChartDataEntry] = []
    
    @State var pieSliceDescription: String = NSLocalizedString("Expenses by Category", comment: "").uppercased()
    @State var selectedBarDescription: String = ""
    @State var selectedCategory: String = Categories.Income
    
    
    @Binding var getPreviousMonthBudget: Bool
    @Binding var getNextMonthBudget: Bool
    @Binding var hideLeftChevron: Bool
    @Binding var hideRightChevron: Bool
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                }
                .frame(width: geo.size.width, height: geo.size.height / 6, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [CustomColors.TopColorGradient2, Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                .ignoresSafeArea(.all, edges: .top)
                .navigationBarTitle (Text(LocalizedStringKey("ANALYTICS")), displayMode: .inline)
                VStack {
                    VStack {
                        Picker(selection: self.$selectedCategory, label: Text("")) {
                            Text(LocalizedStringKey(Categories.Income)).tag(Categories.Income)
                            Text(LocalizedStringKey(Categories.Expense)).tag(Categories.Expense)
                            Text(LocalizedStringKey(Categories.Saving)).tag(Categories.Saving)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(CustomColors.IncomeGradient2).colorInvert()
                        .colorMultiply(CustomColors.CloudBlue).colorInvert()
                    }
                    .frame(width: geo.size.width * 0.90)
                    
                    ScrollView {
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
                        
                        VStack {
//                            Text(self.pieSliceDescription.uppercased())
//                                .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
//                                .font(Fonts.light12)
//                                .foregroundColor(CustomColors.ExpensesColor)
//                                .frame(width: geo.size.width * 0.90, alignment: .leading)
//                                .onAppear {
//                                    self.pieSliceDescription = ""
//                                }
//                            Divider()
                            switch self.selectedCategory {
                            case Categories.Income:
                                if !self.entriesForIncome.isEmpty {
                                    PieChart(entries: self.entriesForIncome, pieSliceDescription: self.$pieSliceDescription,
                                             currencySymbol: self.userSettingsVM.settings.currencySymbol,
                                             colors: ChartColorTemplates.incomePastel())
                                        .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5, alignment: .center)
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
                                
                                    
                            case Categories.Expense:
                                if !self.entriesForExpenses.isEmpty {
                                    PieChart(entries: self.entriesForExpenses, pieSliceDescription: self.$pieSliceDescription,
                                             currencySymbol: self.userSettingsVM.settings.currencySymbol,
                                             colors: ChartColorTemplates.expensesPastel())
                                        .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5)
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
                            case Categories.Saving:
                                if !self.entriesForSaving.isEmpty {
                                    PieChart(entries: self.entriesForSaving, pieSliceDescription: self.$pieSliceDescription,
                                             currencySymbol: self.userSettingsVM.settings.currencySymbol, colors: ChartColorTemplates.savingPastel())
                                        .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5)
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
                                
                            default:
                                PieChart(entries: self.entriesForExpenses, pieSliceDescription: self.$pieSliceDescription)
                                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5)
                            }
                            Text(self.selectedBarDescription.uppercased())
                                .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
                                .font(Fonts.light12)
                                .foregroundColor(CustomColors.IncomeGradient1)
                                .frame(width: geo.size.width * 0.90, alignment: .leading)
                                .onAppear {
                                    self.selectedBarDescription = ""
                                }
                            Divider()
                            Text( "\(self.selectedCategory) progress for " + "\(Int(self.currentMonthBudget.year))")
                            switch self.selectedCategory {
                            case Categories.Income:
                                BarChart(selectedCategory: self.$selectedCategory, entries: self.entriesBarChartIncome, selectedBarDescription: self.$selectedBarDescription, currencySymbol: self.userSettingsVM.settings.currencySymbol)
                                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3)
                            case Categories.Expense:
                                BarChart(selectedCategory: self.$selectedCategory, entries: self.entriesBarChartExpenses, selectedBarDescription: self.$selectedBarDescription, currencySymbol: self.userSettingsVM.settings.currencySymbol)
                                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3)
                            case Categories.Saving:
                                BarChart(selectedCategory: self.$selectedCategory, entries: self.entriesBarChartSaving, selectedBarDescription: self.$selectedBarDescription, currencySymbol: self.userSettingsVM.settings.currencySymbol)
                                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3)
                            default:
                                BarChart(selectedCategory: self.$selectedCategory, entries: self.entriesBarChartExpenses, selectedBarDescription: self.$selectedBarDescription, currencySymbol: self.userSettingsVM.settings.currencySymbol)
                                    .frame(width: geo.size.width * 0.90, height: geo.size.height / 3)
                            }
                            
                            
                            
                            
                    }
                        .padding(.horizontal)
                        //.frame(width: geo.size.width * 0.90)
                        VStack {
                         }
                        .frame(height: 120)
                        
                    }
                    
                
                }
               // .ignoresSafeArea(.all, edges: .top)
                .onAppear {
                    coloredNavAppearance.backgroundColor = UIColor(.clear)
                    getEntriesPieChartIncome()
                    getEntriesPieChartExpenses()
                    getEntriesPieChartSavings()
                    
                    self.budgetVM.getTransactions(context: viewContext)
                    self.budgetVM.getBudgetList(context: viewContext)
                    
                    getEntriesBarChart(for: self.selectedCategory)
                    //getEntriesBarChartIncome()
                }
                .onChange(of: self.getPreviousMonthBudget, perform: { value in
                    getEntriesPieChartIncome()
                    getEntriesPieChartExpenses()
                    getEntriesPieChartSavings()
                    
                    self.budgetVM.getTransactions(context: viewContext)
                    self.budgetVM.getBudgetList(context: viewContext)
                    
                    getEntriesBarChart(for: self.selectedCategory)
                })
                .onChange(of: self.getNextMonthBudget, perform: { value in
                    getEntriesPieChartIncome()
                    getEntriesPieChartExpenses()
                    getEntriesPieChartSavings()
                    
                    self.budgetVM.getTransactions(context: viewContext)
                    self.budgetVM.getBudgetList(context: viewContext)
                    
                    getEntriesBarChart(for: self.selectedCategory)
                })
                .onChange(of: self.selectedCategory, perform: { value in
                    getEntriesBarChart(for: self.selectedCategory)
                })
            }
        }
        
    }
    
    
    private func getEntriesPieChartIncome() {
        let incomeByType = currentMonthBudget.incomeByType
        var incomeTotalAmountByCategory: [String : Decimal] = [:]
        for key in incomeByType.keys.sorted() {
            var totalAmount: Decimal = 0
            for transaction in incomeByType[key]! {
                totalAmount += transaction.amount! as Decimal
            }
            incomeTotalAmountByCategory[key] = totalAmount
        }
        
        self.entriesForIncome = incomeTotalAmountByCategory.map({ income in
            PieChartDataEntry(
                value: Double(truncating: NSDecimalNumber(decimal: income.value)),
                label: income.key)
        }).sorted(by: {$0.value > $1.value })
        
        let savingsByType = currentMonthBudget.savingsTotalAmountByType
        self.entriesForSaving = savingsByType.map({ saving in
            PieChartDataEntry(
                value: Double(truncating: NSDecimalNumber(decimal: saving.value)),
                label: saving.key.presentingName,
                icon: UIImage(systemName: saving.key.presentingImageName))
        })
    }
    
    private func getEntriesPieChartExpenses() {
        let expBySubCat = currentMonthBudget.expensesBySubCategory
        var subCat: [String] = []
        var expensesTotalAmountBySubCategory: [String : Decimal] = [:]
        for key in expBySubCat.keys.sorted() {
            subCat.append(key)
        }
        for subCategory in subCat {
            var totalAmount: Decimal = 0
            for transaction in expBySubCat[subCategory]! {
                totalAmount  += transaction.amount! as Decimal
            }
            expensesTotalAmountBySubCategory[subCategory] = totalAmount
            
        }
        self.entriesForExpenses = expensesTotalAmountBySubCategory.map({ expense in
            PieChartDataEntry(
                value: Double(truncating: NSDecimalNumber(decimal: expense.value)),
                label: expense.key,
                icon: UIImage(systemName: Icons.Bicycle))
            
        }).sorted(by: {$0.value > $1.value })
    }
    
    private func getEntriesPieChartSavings() {
        let savingsByType = currentMonthBudget.savingsTotalAmountByType
        self.entriesForSaving = savingsByType.map({ saving in
            PieChartDataEntry(
                value: Double(truncating: NSDecimalNumber(decimal: saving.value)),
                label: saving.key.presentingName,
                icon: UIImage(systemName: saving.key.presentingImageName))
        }).sorted(by: {$0.value > $1.value })
    }
    
    private func getEntriesBarChart(for category: String) {
        var allIncomeInYearByMonth: [Int : NSDecimalNumber] = [:]
        let actualBudgetList = self.budgetVM.budgetList.filter({ $0.month <= self.currentMonthBudget.month && $0.year == self.currentMonthBudget.year })
        let monthsInBudget = actualBudgetList.map({ $0.month})
        for month in monthsInBudget.sorted() {
            switch category {
            case Categories.Income:
                allIncomeInYearByMonth[Int(month) - 1] = self.budgetVM.budgetList.first(where: {$0.month == month})?.totalIncome
                for i in 0..<12 {
                    if !allIncomeInYearByMonth.keys.contains(i) {
                        allIncomeInYearByMonth[i] = 0
                    }
                }
                
                self.entriesBarChartIncome = allIncomeInYearByMonth.map({ income in
                    BarChartDataEntry(x: Double(income.key), y: Double(truncating: income.value))
                })
            case Categories.Expense:
                allIncomeInYearByMonth[Int(month) - 1] = self.budgetVM.budgetList.first(where: {$0.month == month})?.totalExpenses
                for i in 0..<12 {
                    if !allIncomeInYearByMonth.keys.contains(i) {
                        allIncomeInYearByMonth[i] = 0
                    }
                }
                
                self.entriesBarChartExpenses = allIncomeInYearByMonth.map({ income in
                    BarChartDataEntry(x: Double(income.key), y: Double(truncating: income.value))
                })
            case Categories.Saving:
                allIncomeInYearByMonth[Int(month) - 1] = self.budgetVM.budgetList.first(where: {$0.month == month})?.totalSavings
                for i in 0..<12 {
                    if !allIncomeInYearByMonth.keys.contains(i) {
                        allIncomeInYearByMonth[i] = 0
                    }
                }
                
                self.entriesBarChartSaving = allIncomeInYearByMonth.map({ income in
                    BarChartDataEntry(x: Double(income.key), y: Double(truncating: income.value))
                })
            default:
                allIncomeInYearByMonth[Int(month) - 1] = self.budgetVM.budgetList.first(where: {$0.month == month})?.totalIncome
                for i in 0..<12 {
                    if !allIncomeInYearByMonth.keys.contains(i) {
                        allIncomeInYearByMonth[i] = 0
                    }
                }
                
                self.entriesBarChartIncome = allIncomeInYearByMonth.map({ income in
                    BarChartDataEntry(x: Double(income.key), y: Double(truncating: income.value))
                })
            }
            
        }
        
    }
    
    private func getEntriesBarChartIncome() {
        var allIncomeInYearByMonth: [Int : NSDecimalNumber] = [:]
        let actualBudgetList = self.budgetVM.budgetList.filter({ $0.month <= self.currentMonthBudget.month && $0.year == self.currentMonthBudget.year })
        let monthsInBudget = actualBudgetList.map({ $0.month})//.sorted() // self.budgetVM.budgetList.map({ $0.month}).sorted()
        for month in monthsInBudget.sorted() {
            allIncomeInYearByMonth[Int(month) - 1] = self.budgetVM.budgetList.first(where: {$0.month == month})?.totalIncome
        }
        for i in 0..<12 {
            if !allIncomeInYearByMonth.keys.contains(i) {
                allIncomeInYearByMonth[i] = 0
            }
        }
        print(allIncomeInYearByMonth)
        self.entriesBarChartIncome = allIncomeInYearByMonth.map({ income in
            BarChartDataEntry(x: Double(income.key), y: Double(truncating: income.value))
        })
    }
    
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 20.0
        }
    }
    
    
}


/*
 
 Button(action: {
     let shareManager = CSVShareManager()
     let csvData = shareManager.createMonthBudgetCSV(for: currentMonthBudget)
     let path = try? FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
     sendingDataURL = path!.appendingPathComponent("YearBudget.csv")
     try?csvData.write(to: sendingDataURL)
     shareManager.shareCSV(url: sendingDataURL)
 }) {
     Image(systemName: Icons.Doc_Arrow_Down)
         .modifier(CircleModifier(color: GradientColors.Expense, strokeLineWidth: 3.0))
         .frame(width: 40, height: 40, alignment: .center)
         .font(Fonts.light25)
 }
 .onAppear {
     startAnimate()
 }
 */
//struct AnalyticsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalyticsView(currentMonthBudget: .constant(MonthlyBudget()))
//    }
//}

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
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var currentMonthBudget: MonthlyBudget
    @State var sendingDataURL: URL = URL(fileURLWithPath: "")
    @State var offsetY: CGFloat = 0.0
   // @State var expenses: [Transaction] = []
    @State var entriesForExpenses: [PieChartDataEntry] = []
    @State var entriesForIncome: [PieChartDataEntry] = []
    @State var entriesForSaving: [PieChartDataEntry] = []
    @State var pieSliceDescription: String = "Expenses by Category".uppercased()
    @State var selectedCategory: String = Categories.Income
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                VStack(spacing: 0) {
                    Text("CHARTS")
                        .foregroundColor(.gray)
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
                            .frame(width: geo.size.width / 4.2, height: 110, alignment: .center)
                            .font(Fonts.light45)
                    }
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
                    Text("\(currentMonthBudget.monthYearStringPresentation)")
                        .font(Font.system(size: 20, weight: .light, design: .default))
                        .foregroundColor(.black)
                }
                .background(Color.white)
                VStack {
                    Picker(selection: self.$selectedCategory, label: Text("")) {
                        Text(Categories.Income).tag(Categories.Income)
                        Text(Categories.Expense).tag(Categories.Expense)
                        Text(Categories.Saving).tag(Categories.Saving)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                VStack {
                    
                    Text(self.pieSliceDescription.uppercased())
                        .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
                        .font(Fonts.light12)
                        .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        .onAppear {
                            self.pieSliceDescription = ""
                        }
                    Divider()
                    switch self.selectedCategory {
                    case Categories.Income:
                        PieChart(entries: self.entriesForIncome, pieSliceDescription: self.$pieSliceDescription, colors: ChartColorTemplates.incomePastel())
                            .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5, alignment: .center)
                            
                    case Categories.Expense:
                        PieChart(entries: self.entriesForExpenses, pieSliceDescription: self.$pieSliceDescription, colors: ChartColorTemplates.expensesPastel())
                            .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5)
                    case Categories.Saving:
                        PieChart(entries: self.entriesForSaving, pieSliceDescription: self.$pieSliceDescription)
                            .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5)
                    default:
                        PieChart(entries: self.entriesForExpenses, pieSliceDescription: self.$pieSliceDescription)
                            .frame(width: geo.size.width * 0.90, height: geo.size.height / 3.5)
                    }
                    
                    
                    
                }
                .frame(width: geo.size.width * 0.90, height: geo.size.height / 3, alignment: .center)
                
            }
            .onAppear {
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
        }
    }
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 20.0
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(currentMonthBudget: .constant(MonthlyBudget()))
    }
}

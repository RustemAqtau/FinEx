//
//  BarChart.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-27.
//

import SwiftUI
import Charts

struct BarChart: UIViewRepresentable {
    
    @Binding var selectedCategory: String
    let entries: [BarChartDataEntry]
    @Binding var selectedBarDescription: String
    var currencySymbol: String?
    let barChart = BarChartView()
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    func makeUIView(context: Context) -> BarChartView {
        barChart.delegate = context.coordinator
        barChart.chartAnimator.animate(xAxisDuration: 0, yAxisDuration: 1, easingOptionX: .easeInOutCirc, easingOptionY: .easeInOutCirc)
        return barChart
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.label = "Monthly \(self.selectedCategory)"
        uiView.noDataText = "No Data"
        uiView.data = BarChartData(dataSet: dataSet)
        uiView.rightAxis.enabled = false
        uiView.setScaleEnabled(false)
       // uiView.barData?.barWidth = 0.50
        uiView.fitBars = true
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        uiView.notifyDataSetChanged()
        uiView.chartAnimator.animate(xAxisDuration: 0, yAxisDuration: 1, easingOptionX: .easeInOutCirc, easingOptionY: .easeInOutCirc)
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: BarChart
        init(parent: BarChart) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let month = parent.months[Int(entry.x)]
            let amount = entry.y
            parent.selectedBarDescription = "\(amount) you had in \(month)"
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func formatDataSet(dataSet: BarChartDataSet) {
        switch self.selectedCategory {
        case Categories.Income:
            dataSet.colors = ChartColorTemplates.incomeBarPastel()
            dataSet.valueColors = ChartColorTemplates.incomeBarPastel()
        case Categories.Expense:
            dataSet.colors = ChartColorTemplates.expenseBarPastel()
            dataSet.valueColors = ChartColorTemplates.expenseBarPastel()
        case Categories.Saving:
            dataSet.colors = ChartColorTemplates.savingBarPastel()
            dataSet.valueColors = ChartColorTemplates.savingBarPastel()
        default:
            dataSet.colors = ChartColorTemplates.incomeBarPastel()
            dataSet.valueColors = ChartColorTemplates.incomeBarPastel()
        }
        
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.currencySymbol = self.currencySymbol
        formatter.maximumFractionDigits = 0
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
       // leftAxis.labelTextColor = ChartColorTemplates.incomePastel().first!
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
        xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
       // xAxis.labelTextColor = ChartColorTemplates.incomePastel().last!
        xAxis.labelPosition = .bottom
       // xAxis.axisMinimum = -0.5
    }
    
    func formatLegend(legend: Legend) {
        legend.textColor = .red
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.drawInside = true
        legend.yOffset = 30
    }
}

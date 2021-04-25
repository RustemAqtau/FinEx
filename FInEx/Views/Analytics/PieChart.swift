//
//  PieChart.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-21.
//

import SwiftUI
import Charts

struct PieChart: UIViewRepresentable {
    var entries: [PieChartDataEntry]
    @Binding var pieSliceDescription: String
    @State var colors: [NSUIColor] = ChartColorTemplates.incomePastel()
    let pieChart = PieChartView()
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        pieChart.chartAnimator.animate(xAxisDuration: 1, yAxisDuration: 1, easingOptionX: .easeInOutCirc, easingOptionY: .easeInOutCirc)
        return pieChart
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = colors
        let pieChartData = PieChartData(dataSet: dataSet)
        uiView.data = pieChartData
        configureChart(uiView)
        formatCenter(uiView)
        formatDescription(uiView.chartDescription)
        formatLegend(uiView.legend)
        formatDataSet(dataSet)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: PieChart
        init(parent: PieChart) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let labelText = entry.value(forKey: "label")! as! String
            let number = entry.value(forKey: "value")! as! Double
           
            parent.pieSliceDescription = labelText + " • \(number)"
          // parent.pieChart.centerTextOffset = CGPoint(x: 0, y: 0 - (parent.pieChart.radius + 15))
            
        }
        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            parent.pieSliceDescription = NSLocalizedString("Expenses by Category", comment: "").uppercased()
        }
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
        
    }
    
    func configureChart(_ pieChart: PieChartView) {
        pieChart.rotationEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        //pieChart.extraLeftOffset = 70
        //pieChart.extraBottomOffset = 40
        //pieChart.extraRightOffset = 20
    }
    
    func formatCenter(_ pieChart: PieChartView) {
        pieChart.holeColor = .white
        pieChart.holeRadiusPercent = 0.5
        pieChart.drawSlicesUnderHoleEnabled = true
        //pieChart.centerText = "Expenses"
    }
    
    func formatDescription( _ description: Description?) {
        description?.text = "Description"
        description?.position = CGPoint(x: 100, y: -20)
        description?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        description?.font = UIFont(name: "Avenir", size: 16)!
        description?.textAlign = .center
    }
    
    func formatLegend(_ legend: Legend) {
        legend.enabled = true
        legend.font = UIFont(name: "Avenir", size: 14)!
        legend.form = .circle
        legend.formLineDashPhase = .greatestFiniteMagnitude
        legend.orientation = .vertical
        legend.formToTextSpace = 8.0
        legend.formSize = 14
        legend.verticalAlignment = .center
        legend.drawInside = false
        legend.textWidthMax = 40
    }
    
    func formatDataSet(_ dataSet: ChartDataSet) {
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
       
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(entries: [], pieSliceDescription: .constant(""))
    }
}

//
//  ShareSeet.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-20.
//

import UIKit
import SwiftUI

struct CSVShareManager {
    func shareCSV(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToTwitter
        ]
        
        activityViewController.isModalInPresentation = true
        let viewController = Coordinator.topViewController()
        activityViewController.popoverPresentationController?.sourceView = viewController?.view
        viewController?.present(activityViewController, animated: true, completion: nil)
      }
    
    func createMonthBudgetCSV(for md: MonthlyBudget) -> NSData {
        
        let descArr = ["-", "Income", "Expenses", "Savings"]
        let columnCount = 5
        var lines = [[""]]
        var columns = [""]
        columns.insert("Description", at: 0)
        lines.removeAll()
        for desc in descArr {
            switch desc {
            
            case "-":
                var line = Array<String>(repeating: "", count: columnCount)
                line[0] = md.monthYearStringPresentation
                line[1] = ""
                line[2] = ""
                line[3] = ""
                line[4] = ""
                lines.append(line)
            
                var secondLine = Array<String>(repeating: "", count: columnCount)
                secondLine[0] = ""
                secondLine[1] = NSLocalizedString("Category", comment: "")
                secondLine[2] = NSLocalizedString("Amount", comment: "")
                secondLine[3] = NSLocalizedString("Date", comment: "")
                secondLine[4] = NSLocalizedString("Note", comment: "")
                lines.append(secondLine)
                
            case "Income":
                var line = Array<String>(repeating: "", count: columnCount)
                line[0] = NSLocalizedString(desc, comment: "")
                line[1] = "Total"
                line[2] = md.totalIncome.description
                lines.append(line)
                for key in md.incomeByType.keys {
                    for inc in md.incomeByType[key]! {
                        var line = Array<String>(repeating: "", count: columnCount)
                        line[0] = ""
                        line[1] = NSLocalizedString(key, comment: "")
                        line[2].append(inc.amountDecimal.description)
                        line[3].append(setDateForCSV(date: inc.date!).replacingOccurrences(of: ",", with: " "))
                        line[4].append(inc.notePresentation)
                        lines.append(line)
                    }
                }
                
            case "Expenses":
                var line = Array<String>(repeating: "", count: columnCount)
                line[0] = NSLocalizedString(desc, comment: "")
                line[1] = "Total"
                line[2] = md.totalExpenses.description
                lines.append(line)
                for key in md.expensesBySubCategory.keys {
                    for exp in md.expensesBySubCategory[key]! {
                        var line = Array<String>(repeating: "", count: columnCount)
                        line[0] = ""
                        line[1] = NSLocalizedString(exp.type!.presentingName, comment: "")
                        line[2].append(exp.amountDecimal.description)
                        line[3].append(setDateForCSV(date: exp.date!).replacingOccurrences(of: ",", with: " "))
                        line[4].append(exp.notePresentation)
                        lines.append(line)
                    }
                }

            case "Savings":
                var line = Array<String>(repeating: "", count: columnCount)
                line[0] = NSLocalizedString(desc, comment: "")
                line[1] = "Total"
                line[2] = md.totalSavings.description
                lines.append(line)
                for key in md.savingsTotalAmountByType.keys {
                    var line = Array<String>(repeating: "", count: columnCount)
                    line[0] = ""
                    line[1] = NSLocalizedString(key.presentingName, comment: "")
                    line[2] = md.savingsTotalAmountByType[key]!.description
                    lines.append(line)
                }

            default:
                var line = Array<String>(repeating: "", count: columnCount)
                line[0].append("Unknown")
            }
        }
        
        func csvDataForLines(input: [[String]]) -> NSData {
            return input.map {
                $0.joined(separator: ",")
            }.joined(separator: "\n").data(using: .utf8)! as NSData
        }
        return csvDataForLines(input: lines)
    }
     
}

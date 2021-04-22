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
        
        var lines = [[""]]
        var columns = [""]
        columns.insert("Description", at: 0)
        
        for desc in descArr {
            switch desc {
            
            case "-":
                var line = Array<String>(repeating: "", count: 3)
                line[0] = ""
                line[1] = ""
                line[2] = md.monthYearStringPresentation
                lines.append(line)
            case "Income":
                var line = Array<String>(repeating: "", count: 3)
                line[0] = desc
                line[1] = ""
                line[2] = ""
                lines.append(line)
                for key in md.incomeByDate.keys {
                    var line = Array<String>(repeating: "", count: 3)
                    line[0] = ""
                    line[1] = key
                    line[2] = ""
                    lines.append(line)
                    for inc in md.incomeByDate[key]! {
                        var line = Array<String>(repeating: "", count: 3)
                        line[0] = ""
                        line[1] = ""
                        line[2].append("$" + inc.amountDecimal.description)
                        lines.append(line)
                    }
                }
            case "Expenses":
                var line = Array<String>(repeating: "", count: 3)
                line[0] = desc
                line[1] = ""
                line[2] = ""
                lines.append(line)
                for key in md.expensesBySubCategory.keys {
                    var line = Array<String>(repeating: "", count: 3)
                    line[0] = ""
                    line[1] = key
                    line[2] = ""
                    lines.append(line)
                    for exp in md.expensesBySubCategory[key]! {
                        var line = Array<String>(repeating: "", count: 3)
                        line[0] = ""
                        line[1] = ""
                        line[2].append("$" + exp.amountDecimal.description)
                        lines.append(line)
                        
                    }
                }
            case "Savings":
                var line = Array<String>(repeating: "", count: 3)
                line[1].append("saving")
            default:
                var line = Array<String>(repeating: "", count: 3)
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

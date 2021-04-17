//
//  MonthlyBudget.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-12.
//

import CoreData

extension MonthlyBudget {
    
    var monthYearStringPresentation: String {
        switch month {
        case 1: return "January, \(year)"
        case 2: return "February, \(year)"
        case 3: return "March, \(year)"
        case 4: return "April, \(year)"
        case 5: return "May, \(year)"
        case 6: return "June, \(year)"
        case 7: return "July, \(year)"
        case 8: return "August, \(year)"
        case 9: return "September, \(year)"
        case 10: return "October, \(year)"
        case 11: return "November, \(year)"
        case 12: return "December, \(year)"
        default: return "Unknown"
        }
    }
    
    var savingsBySubCategory: [String : [Transaction]] {
        var dic: [String: [Transaction]] = [
            SvaingSubCategories.LongTerm.rawValue : [],
            SvaingSubCategories.ShortTerm.rawValue : []
        ]
        
        for key in dic.keys {
            for saving in savingsList {
                if saving.type?.subCategory == key {
                    dic[key]?.append(saving)
                }
            }
        }
        
        for elem in dic {
            if elem.value.isEmpty {
                dic.removeValue(forKey: elem.key)
            }
        }
        return dic
    }
    
    var incomeByDate: [String: [Transaction]] {
        var dic: [String: [Transaction]] = [:]
        let dates = incomeList.map({ transaction in setDate(date: transaction.date!)  })
        for date in dates {
            var arr: [Transaction] = []
            for transaction in incomeList {
                if date == setDate(date: transaction.date!)  {
                    arr.append(transaction)
                }
            }
            dic[date] = arr
        }
        return dic
    }
    
    var expensesBySubCategory: [String : [Transaction]] {
        var dic: [String: [Transaction]] = [ExpenseSubCategories.Bills.rawValue : [],
                   ExpenseSubCategories.Entertainment.rawValue : [],
                   ExpenseSubCategories.FoodAndDrinks.rawValue : [],
                   ExpenseSubCategories.Health.rawValue : [],
                   ExpenseSubCategories.Insurance.rawValue : [],
                   ExpenseSubCategories.Subscriptions.rawValue : [],
                   ExpenseSubCategories.Transportation.rawValue : [],
                   ExpenseSubCategories.Travel.rawValue : []
        ]
        
        for key in dic.keys {
            for expense in expensesList {
                if expense.type?.subCategory == key {
                    dic[key]?.append(expense)
                }
            }
        }
        
        for elem in dic {
            if elem.value.isEmpty {
                dic.removeValue(forKey: elem.key)
            }
        }
        return dic
    }
    
    var totalIncome: NSDecimalNumber {
        var amount:Decimal = 0.0
        if !incomeList.isEmpty {
            for income in incomeList {
                amount += (income.amount as Decimal?)!
            }
        }
        return NSDecimalNumber(decimal: amount)
    }
    
    var totalExpenses: NSDecimalNumber {
        var amount:Decimal = 0.0
        if !expensesList.isEmpty {
            for expense in expensesList {
                amount += (expense.amount as Decimal?)!
            }
        }
        return NSDecimalNumber(decimal: amount)
    }
    
    var totalSavings: NSDecimalNumber {
        var amount:Decimal = 0.0
        if !savingsList.isEmpty {
            for saving in savingsList {
                amount += (saving.amount as Decimal?)!
            }
        }
        return NSDecimalNumber(decimal: amount)
    }
    
    var incomeList: [Transaction] {
        if let income = getIncome(context: self.managedObjectContext!) {
            return income
        }
        return []
    }
    
    var expensesList: [Transaction] {
        if let expenses = getExpenses(context: self.managedObjectContext!) {
            return expenses
        }
        return []
    }
    
    var savingsList: [Transaction] {
        if let savings = getSavings(context: self.managedObjectContext!) {
            return savings
        }
        return []
    }
    
    private func getIncome(context: NSManagedObjectContext) -> [Transaction]? {
        let predicate = NSPredicate(format: "monthlyBudget = %@ AND category = %@", argumentArray: [self, Categories.Income])
        let request = Transaction.fetchRequest(predicate: predicate)
        do {
            let fetchedSavings = try? context.fetch(request)
            return fetchedSavings
        }
    }
    
    private func getExpenses(context: NSManagedObjectContext) -> [Transaction]? {
        let predicate = NSPredicate(format: "monthlyBudget = %@ AND category = %@", argumentArray: [self, Categories.Expense])
        let request = Transaction.fetchRequest(predicate: predicate)
        do {
            let fetchedSavings = try? context.fetch(request)
            return fetchedSavings
        }
    }
    
    private func getSavings(context: NSManagedObjectContext) -> [Transaction]? {
        let predicate = NSPredicate(format: "monthlyBudget = %@ AND category = %@", argumentArray: [self, Categories.Saving])
        let request = Transaction.fetchRequest(predicate: predicate)
        do {
            let fetchedSavings = try? context.fetch(request)
            return fetchedSavings
        }
    }
    
    static func update(for date: Date, previousMonthBudget: MonthlyBudget, context: NSManagedObjectContext) {
        let monthlyBudget = MonthlyBudget(context: context)
        let month = getMonthFrom(date: date) ?? 0
        let year = getYearFrom(date: date) ?? 0
        monthlyBudget.month = Int32(month)
        monthlyBudget.year = Int32(year)
        monthlyBudget.previousMonthBalance = previousMonthBudget.balance
        for transaction in previousMonthBudget.savingsList {
            Transaction.update(from: transaction, monthlyBudget: monthlyBudget, context: context)
        }
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func update(for date: Date, context: NSManagedObjectContext) {
        let monthlyBudget = MonthlyBudget(context: context)
        let month = getMonthFrom(date: date) ?? 0
        let year = getYearFrom(date: date) ?? 0
        monthlyBudget.month = Int32(month)
        monthlyBudget.year = Int32(year)
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<MonthlyBudget> {
        let request = NSFetchRequest<MonthlyBudget>(entityName: "MonthlyBudget")
        request.sortDescriptors = [NSSortDescriptor(key: "month", ascending: true)]
        request.predicate = predicate
        return request
    }
}

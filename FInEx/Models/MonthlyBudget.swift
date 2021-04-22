//
//  MonthlyBudget.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-12.
//

import CoreData

extension MonthlyBudget {
    
    
    var monthYearStringPresentation: String {
        if !expensesList.isEmpty {
            if let lastExpense = expensesList.last,
               let date = lastExpense.date {
                return setDateMMYY(date: date)
            }
        }
        let currentDate = Date()
        return setDateMMYY(date: currentDate)
        
    }
    
    // MARK: - Income
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
    
    var totalIncome: NSDecimalNumber {
        var amount:Decimal = 0.0
        if !incomeList.isEmpty {
            for income in incomeList {
                amount += (income.amount as Decimal?)!
            }
        }
        return NSDecimalNumber(decimal: amount)
    }
    
    var incomeList: [Transaction] {
        if let income = getTransactions(for: Categories.Income, context: self.managedObjectContext!) {
            return income
        }
        return []
    }
    
    var incomeByType: [String : [Transaction]] {
        let types = incomeList.map({ income in
            income.type?.name
        })
        var result: [String : [Transaction] ] = [:]
        for type in types {
            var arr: [Transaction] = []
            for transaction in incomeList {
                if transaction.type?.name == type {
                    arr.append(transaction)
                }
            }
            result[type!] = arr
        }
        return result
    }
    
    // MARK: - Expenses
    var expensesBySubCategory: [String : [Transaction]] {
        var dic: [String: [Transaction]] = [
                    
            ExpenseSubCategories.Entertainment.rawValue : [],
            ExpenseSubCategories.Housing.rawValue : [],
            ExpenseSubCategories.Bills.rawValue : [],
            ExpenseSubCategories.FoodAndDrinks.rawValue : [],
            ExpenseSubCategories.Shopping.rawValue : [],
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
    
    var totalExpenses: NSDecimalNumber {
        var amount:Decimal = 0.0
        if !expensesList.isEmpty {
            for expense in expensesList {
                amount += (expense.amount as Decimal?)!
            }
        }
        return NSDecimalNumber(decimal: amount)
    }
    
    var expensesList: [Transaction] {
        if let expenses = getTransactions(for: Categories.Expense ,context: self.managedObjectContext!) {
            return expenses
        }
        return []
    }
    
    
    
    // MARK: - Savings
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
    
    var savingsByType: [String : [TransactionType : Decimal]] {
        var dicRes: [String: [TransactionType : Decimal]] = [:]
        let dic = savingsBySubCategory
        for key in dic.keys.sorted() {
            var dic2: [TransactionType: Decimal] = [:]
            let types = dic[key]!.map({ saving in saving.type })
            for type in types {
                var total: Decimal = 0
                for saving in dic[key]! {
                    if saving.type == type {
                        total += saving.amount! as Decimal
                    }
                }
                dic2[type!] = total
            }
            dicRes[key] = dic2
        }
        
        return dicRes
        
    }
    
    var savingsTotalAmountByType: [TransactionType : Decimal] {
        let types = savingsList.map({ saving in
            saving.type
        })
        var result: [TransactionType : Decimal] = [:]
        for type in types {
            var totalAmount: Decimal = 0
            for trans in savingsList {
                if trans.type == type {
                    totalAmount += trans.amount! as Decimal
                }
            }
            result[type!] = totalAmount
        }
        return result
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
    
    var savingsList: [Transaction] {
        if let savings = getTransactions(for: Categories.Saving, context: self.managedObjectContext!) {
            return savings
        }
        return []
    }
    
    
    
    // MARK: - private func
    private func getTransactions(for category: String, context: NSManagedObjectContext) -> [Transaction]? {
        let predicate = NSPredicate(format: "monthlyBudget = %@ AND category = %@", argumentArray: [self, category])
        let request = Transaction.fetchRequest(predicate: predicate)
        do {
            let fetchedSavings = try? context.fetch(request)
            return fetchedSavings
        }
    }
    
    
    
    // MARK: - static func
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

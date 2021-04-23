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
        if let context = self.managedObjectContext {
            if let income = getTransactions(for: Categories.Income, context: context) {
                return income
            }
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
    
    var incomeTotalAmountByType: [String : Decimal] {
        var result: [String : Decimal] = [:]
        for key in incomeByType.keys {
            var totalAmount: Decimal = 0
            for transaction in incomeByType[key]! {
                totalAmount += transaction.amount! as Decimal
            }
            result[key] = totalAmount
        }
        return result
    }
    
    // MARK: - Expenses
    
    
    var expensesBySubCategory: [String : [Transaction]] {
        print("expensesList: \(expensesList.count)")
        let subCats = expensesList.map({ transaction in transaction.type?.subCategory })
        print("subCats\(subCats)")
        var result: [String : [Transaction]] = [:]
        for subCat in subCats {
            var arr: [Transaction] = []
            for expense in expensesList {
                if expense.type?.subCategory == subCat {
                    arr.append(expense)
                }
            }
            result[subCat!] = arr
        }

        return result
    }
    
    var expensesTotalAmountBySubCategory: [String : Decimal] {
        var result: [String : Decimal] = [:]
        for key in expensesBySubCategory.keys {
            var totalAmount: Decimal = 0
            for transaction in expensesBySubCategory[key]! {
                totalAmount += transaction.amount! as Decimal
            }
            result[key] = totalAmount
        }
        return result
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
        if let context = self.managedObjectContext {
            if let expenses = getTransactions(for: Categories.Expense ,context: context) {
                return expenses
            }
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
        if let context = self.managedObjectContext {
            if let savings = getTransactions(for: Categories.Saving, context: context) {
                return savings
            }
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
        
        let month = getMonthFrom(date: date) ?? 0
        let year = getYearFrom(date: date) ?? 0
        for number in 1...month {
            let monthlyBudget = MonthlyBudget(context: context)
            monthlyBudget.month = Int32(number)
            monthlyBudget.year = Int32(year)
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
        
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<MonthlyBudget> {
        let request = NSFetchRequest<MonthlyBudget>(entityName: "MonthlyBudget")
        request.sortDescriptors = [NSSortDescriptor(key: "month", ascending: true)]
        request.predicate = predicate
        return request
    }
}
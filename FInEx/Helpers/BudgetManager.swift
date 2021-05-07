//
//  BudgetVM.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-12.
//

import CoreData
import Combine

class BudgetManager: ObservableObject {
    @Published var budgetList: [MonthlyBudget] = []
    @Published var transactionList: [Transaction] = []
    @Published var transactionEdited: Bool = false
    
    func addRecurringTransaction(info: RecurringTransaction, monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
        Transaction.update(from: info, monthlyBudget: monthlyBudget, context: context)
    }
    
    func editTransaction(transaction: Transaction, info: TransactionInfo, context: NSManagedObjectContext) {
        transaction.edit(info: info, context: context)
        getTransactions(context: context)
        transactionEdited.toggle()
    }
    
    func deleteTransaction(transaction: Transaction, context: NSManagedObjectContext) {
        transaction.delete(context: context)
        getTransactions(context: context)
    }
    
    func addNewTransaction(info: TransactionInfo, monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
        Transaction.update(from: info, monthlyBudget: monthlyBudget, context: context)
        getTransactions(context: context)
    }
    
    func setCurrentMonthlyBudget(context: NSManagedObjectContext, previousMonthBudget: MonthlyBudget, currentDate: Date) {
        MonthlyBudget.update(for: currentDate, previousMonthBudget: previousMonthBudget, context: context)
    }
    
    func setFirstMonthlyBudget(context: NSManagedObjectContext, currentDate: Date) {
        MonthlyBudget.update(for: currentDate, context: context)
    }
    
    func checkMonthlyBudgetIsEmpty(context: NSManagedObjectContext) -> Bool {
        let budgetList = fetchMonthlyBudget(context: context)
        return budgetList.isEmpty
    }
    
    func getBudgetList(context: NSManagedObjectContext) {
        budgetList = fetchMonthlyBudget(context: context)
    }
    
    func getTransactions(context: NSManagedObjectContext) {
        transactionList = fetchTransactions(context: context)
    }
    private func fetchTransactions(context: NSManagedObjectContext) -> [Transaction] {
        var budgetList: [Transaction] = []
        let predicate = NSPredicate(format: "monthlyBudget != nil")
        let requset = Transaction.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(requset)
            budgetList.removeAll()
            budgetList = result
        } catch {
            print("Error fetching MonthlyBudget: \(error)")
        }
        return budgetList
    }
    
    private func fetchMonthlyBudget(context: NSManagedObjectContext) -> [MonthlyBudget] {
        var budgetList: [MonthlyBudget] = []
        let predicate = NSPredicate(format: "month > 0")
        let requset = MonthlyBudget.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(requset)
            budgetList.removeAll()
            budgetList = result
        } catch {
            print("Error fetching MonthlyBudget: \(error)")
        }
        return budgetList
    }
    
}

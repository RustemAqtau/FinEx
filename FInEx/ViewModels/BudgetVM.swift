//
//  BudgetVM.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-12.
//

import CoreData
import Combine

class BudgetVM: ObservableObject {
    @Published var budgetList: [MonthlyBudget] = []
    
    
    
    func addNewTransaction(info: TransactionInfo, monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
        Transaction.update(from: info, monthlyBudget: monthlyBudget, context: context)
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

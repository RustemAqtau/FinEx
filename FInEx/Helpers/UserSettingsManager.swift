//
//  UserSettingsVM.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-10.
//

import Combine
import CoreData
import SwiftUI

class UserSettingsManager: ObservableObject {
    
    @Published var settings = UserSettings()
    @Published var transactionTypes: [TransactionType] = []
    @Published var transactiontypesByCategoty: [String : [String : [TransactionType]]] = [
        Categories.Income: [Categories.Income:[]],
        Categories.Expense : [
            ExpenseSubCategories.Bills.rawValue:[],
            ExpenseSubCategories.Housing.rawValue : [],
            ExpenseSubCategories.Entertainment.rawValue : [],
            ExpenseSubCategories.FoodAndDrinks.rawValue : [],
            ExpenseSubCategories.Shopping.rawValue : [],
            ExpenseSubCategories.Health.rawValue : [],
            ExpenseSubCategories.Insurance.rawValue : [],
            ExpenseSubCategories.Subscriptions.rawValue : [],
            ExpenseSubCategories.Transportation.rawValue : [],
            ExpenseSubCategories.Travel.rawValue : []],
        Categories.Saving : [SvaingSubCategories.LongTerm.rawValue : [],
                             SvaingSubCategories.ShortTerm.rawValue : []]]
    let categories = [Categories.Income, Categories.Expense, Categories.Saving]
    
    var subCategories: [String: [String]] {
        var arr: [String: [String]] = [Categories.Income : [], Categories.Expense : [], Categories.Saving : []]
        
        arr[Categories.Income]!.append(Categories.Income)
        
        for elem in ExpenseSubCategories.allCases {
            arr[Categories.Expense]!.append(elem.rawValue)
        }
        for elem in SvaingSubCategories.allCases {
            arr[Categories.Saving]?.append(elem.rawValue)
        }
        return arr
    }
    
    @Published var recurringTransactions: [RecurringTransaction] = []
    @Published var recurringTransactionsByCategory: [String: [RecurringTransaction]] = [:]
    @Published var recurringTransactionsByCategoryForBudget: [String: [RecurringTransaction]] = [:]
     let cetegoriesArray = [Categories.Income, Categories.Expense, Categories.Saving]
    // MARK: - RecurringTransactions
    
    func addNewRecurringTransaction(info: RecurringTransactionInfo, context: NSManagedObjectContext) {
        RecurringTransaction.update(from: info, context: context)
    }
    
    func getRecurringTransactionsByCategory(monthlyBudget: MonthlyBudget, context: NSManagedObjectContext) {
        for category in cetegoriesArray {
            let transactions = fetchRecurringTransaction(for: category, monthlyBudget: monthlyBudget, context: context)
            recurringTransactionsByCategoryForBudget[category] = transactions
        }
    }
    
    func getRecurringTransactionsByCategory(context: NSManagedObjectContext) {
        for category in cetegoriesArray {
            let transactions = fetchRecurringTransaction(for: category, context: context)
            recurringTransactionsByCategory[category] = transactions
        }
    }
    
    private func fetchRecurringTransaction(for category: String, monthlyBudget: MonthlyBudget,  context: NSManagedObjectContext) -> [RecurringTransaction]? {
        var recurringTransactions: [RecurringTransaction] = []
        let predicate = NSPredicate(format: "category = %@ AND (nextAddingYear = %@ AND nextAddingMonth = %@)", argumentArray: [category, monthlyBudget.year, monthlyBudget.month])
        let request = RecurringTransaction.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            recurringTransactions = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return recurringTransactions
    }
    
    private func fetchRecurringTransaction(for category: String, context: NSManagedObjectContext) -> [RecurringTransaction]? {
        var recurringTransactions: [RecurringTransaction] = []
        let predicate = NSPredicate(format: "category = %@", argumentArray: [category])
        let request = RecurringTransaction.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            recurringTransactions = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return recurringTransactions
    }
    
    
    func getRecurringTransactions(context: NSManagedObjectContext) {
        recurringTransactions = fetchRecurringTransactions(context: context)
    }
    
    private func fetchRecurringTransactions(context: NSManagedObjectContext) -> [RecurringTransaction] {
        var recurringTransactions: [RecurringTransaction] = []
        let predicate = NSPredicate(format: "amount != nil")
        let request = RecurringTransaction.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            recurringTransactions = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return recurringTransactions
    }
    
    // MARK: - UserSettings
    
    func fetchUserSettins(context: NSManagedObjectContext) -> [UserSettings] {
        var userSettings:[UserSettings] = []
        let predicate = NSPredicate(format: "settingsId > 0")
        let request = UserSettings.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            userSettings = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return userSettings
    }
    
    func checkUserSettingsIsEmpty(context: NSManagedObjectContext) -> Bool {
        let userSettings = fetchUserSettins(context: context)
        return userSettings.isEmpty
    }
    
    func setUserSettings(context: NSManagedObjectContext) {
        let newUserSettingdInfo = UserSettingsInfo(settingsId: 1, isSignedWithAppleId: false, isSetPassCode: false)
        UserSettings.update(from: newUserSettingdInfo, context: context)
    }
    
    func getUserSettings(context: NSManagedObjectContext) {
        let fetchedSettings = fetchUserSettins(context: context)
        settings = fetchedSettings[0]
    }
    
    
    // MARK: - TransactionTypes
    
    func addNewTransactiontype(info: TransactionTypeInfo, context: NSManagedObjectContext) {
        TransactionType.update(from: info, context: context)
    }
    
    func loadDefaultTransactionTypes(context: NSManagedObjectContext) {
        for type in defaultTransactionTypes {
            TransactionType.update(from: type, context: context)
        }
        
    }
    
    func getTransactiontypes(context: NSManagedObjectContext) {
        transactionTypes = fetchTransactionTypes(context: context)
        for key in transactiontypesByCategoty.keys {
            for subKey in transactiontypesByCategoty[key]!.keys {
                transactiontypesByCategoty[key]?[subKey]?.removeAll()
                if key == Categories.Income {
                    for type in transactionTypes {
                        if type.category == key && type.subCategory == nil {
                            transactiontypesByCategoty[Categories.Income]?[Categories.Income]?.append(type)
                        }
                    }
                }
                for type in transactionTypes {
                    if type.category == key {
                        if type.subCategory != nil && type.subCategory == subKey {
                            transactiontypesByCategoty[key]?[subKey]?.append(type)
                        }
                    }
                }
            }
        }
        print("transactiontypesByCategoty: \(transactiontypesByCategoty)")
    }
    
    private func fetchTransactionTypes(context: NSManagedObjectContext) -> [TransactionType] {
        var transactionTypes: [TransactionType] = []
        let predicate = NSPredicate(format: "name != nil")
        let request = TransactionType.fetchRequest(predicate: predicate)
        do {
            let result = try context.fetch(request)
            transactionTypes = result
        } catch {
            print("Error fetching context: \(error)")
        }
        return transactionTypes
    }
    
    func checkTransactionTypesIsEmpty(context: NSManagedObjectContext) -> Bool {
        let transactionTypes = fetchTransactionTypes(context: context)
        return transactionTypes.isEmpty
    }
    
    var defaultTransactionTypes: [TransactionTypeInfo] {
        return [
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Salary", imageName: "briefcase.fill", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Bonus", imageName: "bag.fill.badge.plus", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Pension", imageName: "p.square", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Dividends", imageName: "banknote.fill", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Interest", imageName: "building.columns.fill", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Child benefit", imageName: "staroflife", colorName: "NewBalanceColor", isHidden: false),
            
            //TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: "Rent", imageName: "house.circle.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: "Loan", imageName: "house.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: "Maintenance", imageName: "hammer.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Housing.rawValue, name: "Furniture", imageName: "bed.double.fill", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: "Internet", imageName: "wifi", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: "Electricity", imageName: "bolt.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: "Heating", imageName: "flame.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: "Water", imageName: "drop", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: "Mobile", imageName: "phone.connection", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Cinema", imageName: "film", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Concert", imageName: "guitars", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Hobby", imageName: "paintpalette", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Bowling", imageName: "person.3", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Nightclub", imageName: "timelapse", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Party", imageName: "person.2.square.stack", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: "Resraurant", imageName: "r.square", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: "Groceries", imageName: "cart", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: "Delivery", imageName: "shippingbox.fill", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.rawValue, name: "Clothing", imageName: "creditcard.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.rawValue, name: "Device", imageName: "gamecontroller", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Shopping.rawValue, name: "Accessories", imageName: "eyeglasses", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Insurance.rawValue, name: "Car", imageName: "car", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Subscriptions.rawValue, name: "TV", imageName: "tv", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Subscriptions.rawValue, name: "Music", imageName: "music.note.list", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: "Loan", imageName: "car.circle.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: "Gas", imageName: "gauge", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: "Parking", imageName: "p.circle.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: "Public Tr.", imageName: "tram.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: "Repair", imageName: "wrench.fill", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Health.rawValue, name: "Dentist", imageName: "mouth.fill", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Health.rawValue, name: "Check-Up", imageName: "stethoscope", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Travel.rawValue, name: "Flight", imageName: "airplane", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Travel.rawValue, name: "Hotel", imageName: "building", colorName: "ExpensesColor", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.rawValue, name: "Cash", imageName: "dollarsign.circle.fill", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.rawValue, name: "Investments", imageName: "arrow.up.doc.fill", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.ShortTerm.rawValue, name: "Shopping", imageName: "cart.fill.badge.plus", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.ShortTerm.rawValue, name: "Education", imageName: "graduationcap.fill", colorName: "SavingsColor", isHidden: false)
            
        ]
    }

}


struct UserSettingsVMKey: EnvironmentKey {
    static var defaultValue: UserSettingsManager = UserSettingsManager()
}

//
//  UserSettingsVM.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-10.
//

import Combine
import CoreData

class UserSettingsVM: ObservableObject {
    
    @Published var settings = UserSettings()
    @Published var transactionTypes: [TransactionType] = []
    @Published var transactiontypesByCategoty: [String : [String : [TransactionType]]] = [
        Categories.Income: [Categories.Income:[]],
        Categories.Expense : [ExpenseSubCategories.Bills.rawValue:[],
                              ExpenseSubCategories.Entertainment.rawValue : [],
                              ExpenseSubCategories.FoodAndDrinks.rawValue : [],
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
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Salary", imageName: "dollarsign.circle", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Bonus", imageName: "dollarsign.circle", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Pension", imageName: "dollarsign.circle", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Dividends", imageName: "dollarsign.circle", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Interest", imageName: "dollarsign.circle", colorName: "NewBalanceColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Income, subCategory: nil, name: "Child Benefit", imageName: "dollarsign.circle", colorName: "NewBalanceColor", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Bills.rawValue, name: "Internet", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Cinema", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Concert", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Hobby", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Bowling", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Nightclub", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Entertainment.rawValue, name: "Party", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: "Resraurant", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.FoodAndDrinks.rawValue, name: "Groceries", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Insurance.rawValue, name: "Auto", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Subscriptions.rawValue, name: "Netflix", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: "Gas", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Transportation.rawValue, name: "Parking", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Expense, subCategory: ExpenseSubCategories.Health.rawValue, name: "Dentist", imageName: "dollarsign.circle", colorName: "ExpensesColor", isHidden: false),
            
            
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.rawValue, name: "Cash", imageName: "dollarsign.circle", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.LongTerm.rawValue, name: "Investments", imageName: "dollarsign.circle", colorName: "SavingsColor", isHidden: false),
            TransactionTypeInfo(category: Categories.Saving, subCategory: SvaingSubCategories.ShortTerm.rawValue, name: "Shopping", imageName: "dollarsign.circle", colorName: "SavingsColor", isHidden: false)
            
        ]
    }

}



//
//  UserSettings.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-09.
//

import CoreData

extension UserSettings {
    
    func editColorTheme(value: String, context: NSManagedObjectContext) {
        self.colorTheme = value
             if context.hasChanges {
                 
                 do {
                     try context.save()
                     print("Context saved")
                 } catch {
                     print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editShowDecimals(value: Bool, context: NSManagedObjectContext) {
        self.showDecimals = value
             if context.hasChanges {
                 
                 do {
                     try context.save()
                     print("Context saved")
                 } catch {
                     print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editMonthlyRemainderDay(value: Int, context: NSManagedObjectContext) {
        self.monthlyRemainderDay = Int32(value)
             if context.hasChanges {
                 
                 do {
                     try context.save()
                     print("Context saved")
                 } catch {
                     print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editEnableMonthlyRemainder(value: Bool, context: NSManagedObjectContext) {
        self.enableMonthlyRemainder = value
             if context.hasChanges {
                 
                 do {
                     try context.save()
                     print("Context saved")
                 } catch {
                     print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editDailyRemainderHour(value: String, context: NSManagedObjectContext) {
        self.dailyRemainderHour = value
             if context.hasChanges {
                 
                 do {
                     try context.save()
                     print("Context saved")
                 } catch {
                     print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editEnableDailyRemainder(value: Bool, context: NSManagedObjectContext) {
        self.enableDailyRemainder = value
             if context.hasChanges {
                 
                 do {
                     try context.save()
                     print("Context saved")
                 } catch {
                     print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editCurrencySymbol(value: String, context: NSManagedObjectContext) {
        self.currencySymbol = value
        if context.hasChanges {
            
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editIsSetBiometrix(value: Bool, context: NSManagedObjectContext) {
        self.isSetBiometrix = value
        if context.hasChanges {
            
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editIsSetPassCode(value: Bool, context: NSManagedObjectContext) {
        self.isSetPassCode = value
        if context.hasChanges {
            
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func editIsSignedWithAppleId(value: Bool, context: NSManagedObjectContext) {
        self.isSignedWithAppleId = value
        if context.hasChanges {
            
            do {
                try context.save()
                print("Context saved")
            } catch {
                print("Could not save context")
            }
            
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    static func update(from info: UserSettingsInfo, context: NSManagedObjectContext) {
        
        let setting = UserSettings(context: context)
        setting.settingsId = Int16(info.settingsId)
        setting.isSignedWithAppleId = info.isSignedWithAppleId
        setting.isSetPassCode = info.isSetPassCode
        
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<UserSettings> {
        let request = NSFetchRequest<UserSettings>(entityName: "UserSettings")
        request.sortDescriptors = [NSSortDescriptor(key: "settingsId", ascending: false)]
        request.predicate = predicate
        return request
    }
}



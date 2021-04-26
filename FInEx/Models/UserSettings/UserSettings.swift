//
//  UserSettings.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-09.
//

import CoreData

extension UserSettings {
    
    func changeCurrencySymbol(value: String, context: NSManagedObjectContext) {
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
    
    func changeIsSetBiometrix(value: Bool, context: NSManagedObjectContext) {
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
    
    func changeIsSetPassCode(value: Bool, context: NSManagedObjectContext) {
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
    
    func changeIsSignedWithAppleId(value: Bool, context: NSManagedObjectContext) {
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



//
//  FInExApp.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-06.
//

import SwiftUI

@main
struct FInExApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

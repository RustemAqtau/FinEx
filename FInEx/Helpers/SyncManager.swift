//
//  SyncManager.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-05-08.
//

import SwiftUI
import CoreData
import Combine

class SyncManager: ObservableObject {
    static let shared: SyncManager = SyncManager()
    var cloudEventPublisher: AnyPublisher<Notification, Never>
    func handleCloudEvent(_ notification: Notification, success: @escaping (Bool) -> ()) {
        if let cloudEvent = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
            as? NSPersistentCloudKitContainer.Event {
            // NSPersistentCloudKitContainer sends a notification when an event starts, and another when it
            // ends. If it has an endDate, it means the event finished.
            if cloudEvent.endDate == nil {
                print("Starting an event...") // You could check the type, but I'm trying to keep this brief.
            } else {
                switch cloudEvent.type {
                case .setup:
                    print("Setup finished!")
                case .import:
                    print("An import finished!")
                case .export:
                    print("An export finished!")
                @unknown default:
                    assertionFailure("NSPersistentCloudKitContainer added a new event type.")
                }
                
                if cloudEvent.succeeded {
                    print("And it succeeded!")
                    success(true)
                    
                } else {
                    print("But it failed!")
                    success(false)
                }
                
                if let error = cloudEvent.error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    init() {
        self.cloudEventPublisher =
            NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification).eraseToAnyPublisher()
//                .sink(receiveValue: { notification in
//                    if let cloudEvent = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
//                        as? NSPersistentCloudKitContainer.Event {
//                        // NSPersistentCloudKitContainer sends a notification when an event starts, and another when it
//                        // ends. If it has an endDate, it means the event finished.
//                        if cloudEvent.endDate == nil {
//                            print("Starting an event...") // You could check the type, but I'm trying to keep this brief.
//                        } else {
//                            switch cloudEvent.type {
//                            case .setup:
//                                print("Setup finished!")
//                            case .import:
//                                print("An import finished!")
//                            case .export:
//                                print("An export finished!")
//                                self.syncIsDone = true
//                            @unknown default:
//                                assertionFailure("NSPersistentCloudKitContainer added a new event type.")
//                            }
//
//                            if cloudEvent.succeeded {
//                                print("And it succeeded!")
//                            } else {
//                                print("But it failed!")
//                            }
//
//                            if let error = cloudEvent.error {
//                                print("Error: \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                })
//                .store(in: &disposables)
        }
    

    
}


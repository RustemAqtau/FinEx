//
//  RemaindersView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-29.
//

import SwiftUI

struct RemaindersView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var  hideTabBar: Bool
    
    @State var dailyRemainderTime: DailyRemainderTime = .nineteen
    @State var enableDailyRemainder: Bool = false
    
    @State var monthlyRemainderDay: MonthlyRemainderDay = .one
    @State var enableMonthlyRemainder: Bool = false
    
    @State var showPicker: Bool = false
    @State var isDailyRemainder: Bool = false
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
            }
            .frame(width: geo.size.width, height: geo.size.height / 8, alignment: .center)
            .background(Color.white)
            .ignoresSafeArea(.all, edges: .top)
            .zIndex(100)
            ScrollView {
                VStack(spacing: 30) {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .shadow(radius: 5)
                        VStack(alignment: .leading, spacing: 10) {
                            Text(NSLocalizedString(SettingsContentDescription.reminderTab_field1_title.localizedString(), comment: "").uppercased())
                                .font(Fonts.light12)
                                .multilineTextAlignment(.leading)
                            Text(NSLocalizedString(SettingsContentDescription.reminderTab_description1.localizedString(), comment: ""))
                                .font(Fonts.light15)
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)
                            Divider()
                            HStack {
                                Toggle(isOn: self.$enableDailyRemainder, label: {
                                    HStack {
                                        Text(NSLocalizedString(SettingsContentDescription.reminderTab_field1.localizedString(), comment: ""))
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.gray)
                                            Text(dailyRemainderTime.rawValue)
                                        }
                                        .frame(width: 90, height: 25, alignment: .center)
                                        .onTapGesture {
                                            self.isDailyRemainder = true
                                            self.showPicker.toggle()
                                        }
                                    }
                                    .font(Fonts.light15)
                                    
                                })
                                
                            }
                            
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        .foregroundColor(CustomColors.TextDarkGray)
                        .background(Color.white)
                    }
                    .frame(height: geo.size.height / 4)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .shadow(radius: 5)
                        VStack(alignment: .leading, spacing: 10) {
                            Text(NSLocalizedString(SettingsContentDescription.reminderTab_field2_title.localizedString(), comment: "").uppercased())
                                .font(Fonts.light12)
                                .multilineTextAlignment(.leading)
                            Text(NSLocalizedString(SettingsContentDescription.reminderTab_description2.localizedString(), comment: ""))
                                .font(Fonts.light15)
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)
                            Divider()
                            HStack {
                                Toggle(isOn: self.$enableMonthlyRemainder, label: {
                                    HStack {
                                        Text(NSLocalizedString(SettingsContentDescription.reminderTab_field2.localizedString(), comment: ""))
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.gray)
                                            Text(NSLocalizedString(SettingsContentDescription.reminderTab_field2_pickerLabel.localizedString(), comment: "") + " " + "\(monthlyRemainderDay.rawValue)")
                                        }
                                        .frame(width: 90, height: 25, alignment: .center)
                                        .onTapGesture {
                                            self.isDailyRemainder = false
                                            self.showPicker.toggle()
                                        }
                                    }
                                    .font(Fonts.light15)
                                    
                                })
                            }
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        .foregroundColor(CustomColors.TextDarkGray)
                        .background(Color.white)
                    }
                    .frame(height: geo.size.height / 4)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                
            }
            .overlay(
                VStack {
                    HStack {
                        Text(self.isDailyRemainder ? NSLocalizedString(SettingsContentDescription.reminderTab_field1_pickerDescription.localizedString(), comment: "").uppercased() : NSLocalizedString(SettingsContentDescription.reminderTab_field2_pickerDescription.localizedString(), comment: "").uppercased())
                            .font(Fonts.light12)
                            .frame(width: geo.size.width * 0.50, alignment: .leading)
                        
                        Button(action: {
                            self.showPicker = false
                        }) {
                            Image(systemName: Icons.Checkmark)
                        }
                        .font(Fonts.light20)
                        .frame(width: geo.size.width * 0.30, alignment: .trailing)
                    }
                    .scaledToFit()
                    .frame(width: geo.size.width)
                    .foregroundColor(CustomColors.TextDarkGray)
                    if self.isDailyRemainder {
                        Picker(dailyRemainderTime.rawValue,
                               selection: $dailyRemainderTime){
                            ForEach(DailyRemainderTime.allCases, id: \.self) { time in
                                Text("\(time.rawValue)").tag(time)
                                    .font(Fonts.light25)
                                    .foregroundColor(CustomColors.TextDarkGray)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .textCase(.uppercase)
                        .accentColor(CustomColors.TextDarkGray)
                    } else {
                        Picker("\(monthlyRemainderDay.rawValue)",
                               selection: $monthlyRemainderDay){
                            ForEach(MonthlyRemainderDay.allCases, id: \.self) { day in
                                Text("\(day.rawValue)").tag(day)
                                    .font(Fonts.light25)
                                    .foregroundColor(CustomColors.TextDarkGray)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .textCase(.uppercase)
                        .accentColor(CustomColors.TextDarkGray)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height / 4, alignment: .center)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.80)
                .opacity(self.showPicker ? 1 : 0)
            )
        }
        .navigationBarTitle (Text(""), displayMode: .inline)
        .background(CustomColors.White_Background)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                    self.hideTabBar = false
                                    
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .font(Fonts.regular20)
                                }
        )
        .onAppear {
            
            self.enableDailyRemainder = userSettingsVM.settings.enableDailyRemainder
            if let hour = self.userSettingsVM.settings.dailyRemainderHour  {
                for elem in  DailyRemainderTime.allCases {
                    if hour == elem.rawValue {
                        self.dailyRemainderTime = elem
                    }
                }
            }
            self.enableMonthlyRemainder = userSettingsVM.settings.enableMonthlyRemainder
            for elem in MonthlyRemainderDay.allCases {
                if  elem.rawValue == Int(self.userSettingsVM.settings.monthlyRemainderDay) {
                    self.monthlyRemainderDay = elem
                }
            }
            self.hideTabBar = true
        }
        .onChange(of: self.enableDailyRemainder, perform: { value in
            self.hideTabBar = true
            userSettingsVM.settings.editEnableDailyRemainder(value: self.enableDailyRemainder, context: viewContext)
            if self.enableDailyRemainder {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { granted, error in
                    if granted == true && error == nil {
                        scheduleDailyRemainder()
                        print("Notifications permitted")
                    } else {
                        userSettingsVM.settings.editEnableDailyRemainder(value: false, context: viewContext)
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalNotificationIDs.dailyNotificationID])
                        print("Notifications not permitted")
                    }
                }
            } else {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalNotificationIDs.dailyNotificationID])
            }
        })
        .onChange(of: self.enableMonthlyRemainder, perform: { value in
            self.hideTabBar = true
            userSettingsVM.settings.editEnableMonthlyRemainder(value: self.enableMonthlyRemainder, context: viewContext)
            if self.enableMonthlyRemainder {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { granted, error in
                    if granted == true && error == nil {
                        scheduleMonthlyRemainder()
                        print("Notifications permitted")
                    } else {
                        userSettingsVM.settings.editEnableMonthlyRemainder(value: false, context: viewContext)
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalNotificationIDs.monthlyNotification])
                        print("Notifications not permitted")
                    }
                }
            } else {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalNotificationIDs.monthlyNotification])
            }
        })
        .onChange(of: self.dailyRemainderTime, perform: { value in
            self.hideTabBar = true
            self.userSettingsVM.settings.editDailyRemainderHour(value: self.dailyRemainderTime.rawValue, context: viewContext)
        })
        .onChange(of: self.monthlyRemainderDay, perform: { value in
            self.hideTabBar = true
            self.userSettingsVM.settings.editMonthlyRemainderDay(value: self.monthlyRemainderDay.rawValue, context: viewContext)
        })
        
    }
    
    private func scheduleDailyRemainder() {
        let content = UNMutableNotificationContent()
        content.title = LocalNotificationTexts.dailyTitle.localizedString()
        content.body = LocalNotificationTexts.dailyBody.localizedString()
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        switch self.dailyRemainderTime {
        case .six: dateComponents.hour = 6
        case .seven: dateComponents.hour = 7
        case .eight: dateComponents.hour = 8
        case .nine: dateComponents.hour = 9
        case .ten: dateComponents.hour = 10
        case .eleven: dateComponents.hour = 11
        case .twelve: dateComponents.hour = 12
        case .thirteen: dateComponents.hour = 13
        case .fourteen: dateComponents.hour = 14
        case .fifteen: dateComponents.hour = 15
        case .sixteen: dateComponents.hour = 16
        case .seventeen: dateComponents.hour = 17
        case .eighteen: dateComponents.hour = 18
        case .nineteen: dateComponents.hour = 19
        case .twenty: dateComponents.hour = 20
        case .twentyOne: dateComponents.hour = 21
        case .twentyTwo: dateComponents.hour = 22
            
        }
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: LocalNotificationIDs.dailyNotificationID,
                                            content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    private func scheduleMonthlyRemainder() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString(LocalNotificationTexts.monthlyTitle.localizedString(), comment: "")
        content.body = NSLocalizedString(LocalNotificationTexts.monthlyBody.localizedString(), comment: "")
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        switch self.monthlyRemainderDay {
        case .one: dateComponents.day = 1
        case .two: dateComponents.day = 2
        case .three: dateComponents.day = 3
        case .four: dateComponents.day = 4
        case .five: dateComponents.day = 5
        case .six: dateComponents.day = 6
        case .seven: dateComponents.day = 7
        case .eight: dateComponents.day = 8
        case .nine: dateComponents.day = 9
        case .ten: dateComponents.day = 10
        case .eleven: dateComponents.day = 11
        case .twelve: dateComponents.day = 12
        case .thirteen: dateComponents.day = 13
        case .fourteen: dateComponents.day = 14
        case .fifteen: dateComponents.day = 15
        case .sixteen: dateComponents.day = 16
        case .seventeen: dateComponents.day = 17
        case .eighteen: dateComponents.day = 18
        case .nineteen: dateComponents.day = 19
        case .twenty: dateComponents.day = 20
        case .twentyOne: dateComponents.day = 21
        case .twentyTwo: dateComponents.day = 22
        case .twentyThree: dateComponents.day = 23
        case .twentyFour: dateComponents.day = 24
        case .twentyFive: dateComponents.day = 25
        case .twentySix: dateComponents.day = 26
        case .twentySeven: dateComponents.day = 27
        case .twentyEight: dateComponents.day = 28
        case .twentyNine: dateComponents.day = 29
        case .thirty: dateComponents.day = 30
            
        }
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: LocalNotificationIDs.monthlyNotification,
                                            content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
}



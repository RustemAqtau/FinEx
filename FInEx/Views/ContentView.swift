//
//  ContentView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-06.
//

import SwiftUI
import CoreData
import KeychainAccess
import LocalAuthentication

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userSettingsVM) var userSettingsVM
    @ObservedObject var budgetVM = BudgetManager()
    @State var offsetY: CGFloat = 0.0
    
    @State var themeColor: LinearGradient = Theme.colors[ColorTheme.blue.rawValue]!
    @State var themeColorChanged: Bool = false
    @State var mainButtonTapped: Bool = false
    @State var analyticsButtonTapped: Bool = false
    @State var toolsButtonTapped: Bool = false
    
    @State var incomeSelected = false
    @State var savingsSelected = false
    @State var plusButtonColor = GradientColors.Expense
    @State var plusButtonIsServing = Categories.Expense
    @State var isBudgetView = true
    @State var isAnalyticsView = false
    @State var isSettingsView = false
    
    @State var showAddTransaction: Bool = false
    @State var currentMonthBudget: MonthlyBudget = MonthlyBudget()
    
    @State var getPreviousMonthBudget: Bool = false
    @State var getNextMonthBudget: Bool = false
    @State var hideLeftChevron: Bool = false
    @State var hideRightChevron: Bool = false
    
    @State var coloredNavAppearance = UINavigationBarAppearance()
    let coloredBarButtonAppearance = UIBarButtonItemAppearance ()
    
    @State var askPasscode: Bool = false
    @State var askBiometrix: Bool = false
    
    @State var hideTabBar: Bool = false
    init() {
        setNavBarAppearance()
    }
    
    var body: some View {
        
        VStack {
            GeometryReader() { geo in
                Group {
                    if isSettingsView {
                        SettingsView(hideTabBar: self.$hideTabBar,
                                     themeColorChanged: self.$themeColorChanged,
                                     themeColor: self.$themeColor)
                            .environment(\.userSettingsVM, userSettingsVM)
                        
                    } else if isAnalyticsView {
                        AnalyticsView(coloredNavAppearance: self.$coloredNavAppearance,
                                      currentMonthBudget: self.$currentMonthBudget,
                                      getPreviousMonthBudget: self.$getPreviousMonthBudget,
                                      getNextMonthBudget: self.$getNextMonthBudget,
                                      hideLeftChevron: self.$hideLeftChevron,
                                      hideRightChevron: self.$hideRightChevron,
                                      themeColor: self.$themeColor)
                            .environmentObject(budgetVM)
                            .environment(\.userSettingsVM, userSettingsVM)
                    } else {
                        if !budgetVM.budgetList.isEmpty {
                            BudgetView(currentMonthBudget: self.$currentMonthBudget ,
                                       geo: geo,
                                       plusButtonColor: self.$plusButtonColor,
                                       plusButtonIsServing: self.$plusButtonIsServing,
                                       coloredNavAppearance: self.$coloredNavAppearance,
                                       themeColor: self.$themeColor,
                                       getPreviousMonthBudget: self.$getPreviousMonthBudget,
                                       getNextMonthBudget: self.$getNextMonthBudget,
                                       hideLeftChevron: self.$hideLeftChevron,
                                       hideRightChevron: self.$hideRightChevron,
                                       showAddTransaction: self.$showAddTransaction,
                                       askPasscode: self.$askPasscode)
                                .environmentObject(budgetVM)
                                .environment(\.userSettingsVM, userSettingsVM)
                            
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
            
        }
        .fullScreenCover(isPresented: self.$askPasscode, content: {
            PasscodeField(isNewPasscode: false, askBiometrix: self.askBiometrix)
        })
        .transition(.identity)
        .onAppear {

            let currentDate = Date()
            if self.userSettingsVM.checkUserSettingsIsEmpty(context: viewContext) {
                self.userSettingsVM.setUserSettings(context: viewContext)
                self.userSettingsVM.getUserSettings(context: viewContext)
            }
            let userIsAutorised = checkForExistingUser()
            if userIsAutorised == false {
                if self.userSettingsVM.checkTransactionTypesIsEmpty(context: viewContext) {
                    self.userSettingsVM.loadDefaultTransactionTypes(context: viewContext)
                    self.userSettingsVM.getAllTransactiontypes(context: viewContext)
                }
                
                self.budgetVM.getBudgetList(context: viewContext)
                if self.budgetVM.checkMonthlyBudgetIsEmpty(context: viewContext) {
                    self.budgetVM.setFirstMonthlyBudget(context: viewContext, currentDate: currentDate)
                    self.budgetVM.getBudgetList(context: viewContext)
                }
                updateData()
            }
       }
        .onReceive(SyncManager.shared.cloudEventPublisher, perform: { notification in
            handleCloudEvent(notification)
//            if !self.userSettingsVM.checkUserSettingsIsEmpty(context: viewContext) {
//                if !self.userSettingsVM.settings.isSignedWithAppleId {
//                    self.userSettingsVM.settings.editIsSignedWithAppleId(value: true, context: viewContext)
//                }
//            }
           
        })
        .onChange(of: self.mainButtonTapped, perform: { value in
            if self.isAnalyticsView {
                self.isAnalyticsView = false
                self.plusButtonColor = GradientColors.Expense
                self.plusButtonIsServing = Categories.Expense
            } else if self.isSettingsView {
                self.isSettingsView = false
                self.plusButtonColor = GradientColors.Expense
                self.plusButtonIsServing = Categories.Expense
            } else {
                self.showAddTransaction = true
            }
        })
        .onChange(of: self.analyticsButtonTapped, perform: { value in
            if self.isSettingsView {
                self.isSettingsView.toggle()
            }
            self.isAnalyticsView = true
            self.plusButtonColor = GradientColors.Home
            self.currentMonthBudget = budgetVM.budgetList.last!
        })
        .onChange(of: self.toolsButtonTapped, perform: { value in
            if self.isAnalyticsView {
                self.isAnalyticsView.toggle()
            }
            self.isSettingsView = true
            self.plusButtonColor = GradientColors.Home
        })
        .onChange(of: self.getPreviousMonthBudget, perform: { value in
            if let currentBudgetIndex = self.budgetVM.budgetList.firstIndex(of: self.currentMonthBudget),
               currentBudgetIndex != self.budgetVM.budgetList.startIndex  {
                
                let previousBudgetIndex = self.budgetVM.budgetList.index(before: currentBudgetIndex)
                self.currentMonthBudget = self.budgetVM.budgetList[previousBudgetIndex]
                
            }
        })
        .onChange(of: self.getNextMonthBudget, perform: { value in
            if let currentBudgetIndex = self.budgetVM.budgetList.firstIndex(of: self.currentMonthBudget),
               currentBudgetIndex != self.budgetVM.budgetList.endIndex - 1  {
               
                let nextBudgetIndex = self.budgetVM.budgetList.index(after: currentBudgetIndex)
                self.currentMonthBudget = self.budgetVM.budgetList[nextBudgetIndex]
                
            }
        })
        .onChange(of: self.currentMonthBudget, perform: { value in
            if let currentBudgetIndex = self.budgetVM.budgetList.firstIndex(of: self.currentMonthBudget),
               currentBudgetIndex == self.budgetVM.budgetList.startIndex {
                self.hideLeftChevron = true
            } else {
                self.hideLeftChevron = false
            }
            if let currentBudgetIndex = self.budgetVM.budgetList.firstIndex(of: self.currentMonthBudget),
               currentBudgetIndex == self.budgetVM.budgetList.endIndex - 1 {
                self.hideRightChevron = true
            } else {
                self.hideRightChevron = false
            }
        })
        .onChange(of: self.themeColorChanged, perform: { value in
            setThemeColor()
        })
        .overlay(
            CustomTabBarView(
                             plusButtonColor: self.$plusButtonColor,
                             isBudgetView: self.$isBudgetView,
                             mainButtonTapped: self.$mainButtonTapped,
                             isAnalyticsView: self.$isAnalyticsView,
                             isSettingsView: self.$isSettingsView,
                             toolsButtonTapped: self.$toolsButtonTapped,
                             analyticsButtonTapped: self.$analyticsButtonTapped
            )
            .opacity(self.hideTabBar ? 0 : 1)
        )
        
    }
    
    private func updateData() {
        self.userSettingsVM.getUserSettings(context: viewContext)
        self.userSettingsVM.getAllTransactiontypes(context: viewContext)
        let currentDate = Date()
        let currentMonth = getMonthFrom(date: currentDate)
        self.budgetVM.getBudgetList(context: viewContext)
        if let lastMonthBudget = self.budgetVM.budgetList.last {
            if lastMonthBudget.month < currentMonth! {
                self.budgetVM.setCurrentMonthlyBudget(context: viewContext, previousMonthBudget: lastMonthBudget, currentDate: currentDate)
                self.budgetVM.getBudgetList(context: viewContext)
            }
            self.currentMonthBudget = lastMonthBudget
        }
        
        if userSettingsVM.settings.isSetPassCode {
            self.askPasscode = true
            if userSettingsVM.settings.isSetBiometrix {
                self.askBiometrix = true
            }
        }
        
        if userSettingsVM.settings.currencySymbol == nil {
            let formatter = NumberFormatter()
            formatter.locale = .current
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            userSettingsVM.settings.currencySymbol = formatter.currencySymbol
        }
        setThemeColor()
        self.hideTabBar = false
    }
    
    private func checkForExistingUser() -> Bool {
        let keychain = Keychain(service: KeychainAccessKeys.ServiceName)
        let appleIDCredential = keychain[KeychainAccessKeys.AppleIDCredential]
        return appleIDCredential != nil
    }
    
    private func handleCloudEvent(_ notification: Notification) {
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
                    if self.budgetVM.budgetList.isEmpty {
                        updateData()
                    }
                    
                    
                } else {
                    print("But it failed!")
                }
                
                if let error = cloudEvent.error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    private func getAddingCategory() -> String {
        var addingCategory: String = ""
        switch self.plusButtonIsServing {
        case Categories.Expense:
            addingCategory = Categories.Expense
        case Categories.Income:
            addingCategory = Categories.Income
        case Categories.Saving:
            addingCategory = Categories.Saving
        default:
            addingCategory = Categories.Expense
        }
        return addingCategory
    }
    
    func startAnimate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.offsetY = 20.0
        }
    }
    
    private func setThemeColor() {
        if let colorTheme = self.userSettingsVM.settings.colorTheme {
            switch colorTheme {
            case ColorTheme.purple.rawValue:
                self.themeColor = Theme.colors[ColorTheme.purple.rawValue]!
            case ColorTheme.pink.rawValue:
                self.themeColor = Theme.colors[ColorTheme.pink.rawValue]!
            case ColorTheme.blue.rawValue:
                self.themeColor = Theme.colors[ColorTheme.blue.rawValue]!
            case ColorTheme.orange.rawValue:
                self.themeColor = Theme.colors[ColorTheme.orange.rawValue]!
            case ColorTheme.redOrange.rawValue:
                self.themeColor = Theme.colors[ColorTheme.redOrange.rawValue]!
            default:
                self.themeColor = Theme.colors[ColorTheme.blue.rawValue]!
            }
        }
        
    }
    
    func setNavBarAppearance() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = colorScheme == .dark ? UIColor(CustomColors.White_Background) : UIColor.clear //UIColor(CustomColors.TopBackgroundGradient3)
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor(CustomColors.TextDarkGray), .strokeColor: UIColor.clear, .underlineColor: colorScheme == .dark ? UIColor(CustomColors.White_Background) : UIColor.clear]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gray]
        coloredNavAppearance.shadowColor = colorScheme == .dark ? UIColor(CustomColors.White_Background) : UIColor.clear
        coloredBarButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(CustomColors.TextDarkGray)]
        
        
        coloredNavAppearance.backButtonAppearance = coloredBarButtonAppearance
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UINavigationBar.appearance().standardAppearance.doneButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().compactAppearance?.doneButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().standardAppearance.backButtonAppearance = coloredBarButtonAppearance
        UINavigationBar.appearance().compactAppearance?.backButtonAppearance = coloredBarButtonAppearance
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            ContentView().preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}



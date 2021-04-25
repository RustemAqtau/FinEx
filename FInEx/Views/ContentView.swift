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
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userSettingsVM) var userSettingsVM
    @ObservedObject var budgetVM = BudgetManager()
    @State var offsetY: CGFloat = 0.0
    @State var incomeSelected = false
    @State var savingsSelected = false
    @State var plusButtonColor = GradientColors.Expense
    @State var plusButtonIsServing = Categories.Expense
    @State var isBudgetView = true
    @State var isAnalyticsView = false
    @State var isSettingsView = false
    @State var showAddExpense: Bool = false
    @State var currentMonthBudget: MonthlyBudget = MonthlyBudget()
    
    @State var getPreviousMonthBudget: Bool = false
    @State var getNextMonthBudget: Bool = false
    
    let coloredNavAppearance = UINavigationBarAppearance()
    let coloredBarButtonAppearance = UIBarButtonItemAppearance ()
    
    @State var askPasscode: Bool = false
    @State var askBiometrix: Bool = false
    init() {
        setNavBarAppearance()
    }
    
    var body: some View {
        
        VStack {
            GeometryReader() { geo in
                Group {
                    if isSettingsView {
                        SettingsView()
                            .environment(\.userSettingsVM, userSettingsVM)
                            
                    } else if isAnalyticsView {
                        if let currentBudget = budgetVM.budgetList.last {
                        AnalyticsView(currentMonthBudget: .constant(currentBudget))
                                        .environmentObject(budgetVM)
                            
                        }
                        
                            
                    } else {
                        if !budgetVM.budgetList.isEmpty {
                            BudgetView(currentMonthBudget: self.$currentMonthBudget ,
                                       geo: geo,
                                       plusButtonColor: self.$plusButtonColor,
                                       plusButtonIsServing: self.$plusButtonIsServing,
                                       getPreviousMonthBudget: self.$getPreviousMonthBudget,
                                       getNextMonthBudget: self.$getNextMonthBudget)
                                .environmentObject(budgetVM)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                .overlay(

                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [CustomColors.TopColorGradient2, Color.white]), startPoint: .bottomLeading, endPoint: .topLeading))
                            .frame(width: geo.size.width, height: 120, alignment: .center)
                        
                        Button(action: {
                            if self.isAnalyticsView {
                                self.isAnalyticsView = false
                                self.plusButtonColor = GradientColors.Expense
                                self.plusButtonIsServing = Categories.Expense
                            } else if self.isSettingsView {
                                self.isSettingsView = false
                                self.plusButtonColor = GradientColors.Expense
                                self.plusButtonIsServing = Categories.Expense
                            } else {
                                self.showAddExpense = true
                            }
                            
                        }, label: {
                            Image(systemName: (self.isAnalyticsView || self.isSettingsView) ? "house.fill" : "plus")
                        })
                        .foregroundColor(.white)
                        .modifier(CircleModifier(color: self.plusButtonColor, strokeLineWidth: 3.0))
                        .opacity(0.8)
                        .frame(width: geo.size.width / 5, height: geo.size.height / 8, alignment: .center)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2.3)
                        .sheet(isPresented: self.$showAddExpense, content: {
                            
                                let addingCategory = getAddingCategory()
                                AddTransactionView(currentMonthBudget: self.$currentMonthBudget, category: addingCategory)
                                    .environmentObject(self.budgetVM)
                                    .environment(\.userSettingsVM, self.userSettingsVM)
                            
                            
                        })
                        HStack(alignment: .top , spacing: geo.size.width / 2) {
                            
                            Button(action: {
                                if self.isSettingsView {
                                        self.isSettingsView.toggle()
                                    }
                                    self.isAnalyticsView = true
                                self.plusButtonColor = GradientColors.Home
                                
                            }, label: {
                                Image(systemName: "circle.grid.cross")
                            })
                            Button(action: {
                                if self.isAnalyticsView {
                                    self.isAnalyticsView.toggle()
                                }
                                self.isSettingsView = true
                                self.plusButtonColor = GradientColors.Home
                            }, label: {
                                Image(systemName: "wrench")
                            })
                           
                        }
                        .foregroundColor(.gray)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2.1)
                    }
                    .font(Font.system(size: 30, weight: .medium, design: .default))
                    .position(x: geo.size.width / 2, y: geo.size.height)
                )
            }
        }
        
        
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            if self.userSettingsVM.checkUserSettingsIsEmpty(context: viewContext) {
                self.userSettingsVM.setUserSettings(context: viewContext)
            }
            self.userSettingsVM.getUserSettings(context: viewContext)
            if self.userSettingsVM.checkTransactionTypesIsEmpty(context: viewContext) {

                self.userSettingsVM.loadDefaultTransactionTypes(context: viewContext)
            }
            self.userSettingsVM.getTransactiontypes(context: viewContext)
            
            let currentDate = Date()
            let currentMonth = getMonthFrom(date: currentDate)
            self.budgetVM.getBudgetList(context: viewContext)
            if self.budgetVM.checkMonthlyBudgetIsEmpty(context: viewContext) {
                self.budgetVM.setFirstMonthlyBudget(context: viewContext, currentDate: currentDate)
                self.budgetVM.getBudgetList(context: viewContext)
            }
            if let lastMonthBudget = self.budgetVM.budgetList.last {
                if lastMonthBudget.month < currentMonth! {
                    self.budgetVM.setCurrentMonthlyBudget(context: viewContext, previousMonthBudget: lastMonthBudget, currentDate: currentDate)
                    self.budgetVM.getBudgetList(context: viewContext)
                }
            }
            print("budgetList.count: \(self.budgetVM.budgetList.count)")
            self.currentMonthBudget = budgetVM.budgetList.last!
            
//            if userSettingsVM.settings.isSetPassCode {
//                if userSettingsVM.settings.isSetBiometrix {
//                    self.askBiometrix = true
//                } else {
//                    self.askPasscode = true
//                }
//                
//            }
        }
        .onChange(of: self.getPreviousMonthBudget, perform: { value in
            if let currentBudgetIndex = self.budgetVM.budgetList.firstIndex(of: self.currentMonthBudget),
               currentBudgetIndex != self.budgetVM.budgetList.startIndex  {
                withAnimation(.easeInOut(duration: 1)) {
                    let previousBudgetIndex = self.budgetVM.budgetList.index(before: currentBudgetIndex)
                    self.currentMonthBudget = self.budgetVM.budgetList[previousBudgetIndex]
                }
            }
        })
        .onChange(of: self.getNextMonthBudget, perform: { value in
            if let currentBudgetIndex = self.budgetVM.budgetList.firstIndex(of: self.currentMonthBudget),
               currentBudgetIndex != self.budgetVM.budgetList.endIndex - 1  {
                withAnimation(.easeInOut(duration: 1)) {
                    let nextBudgetIndex = self.budgetVM.budgetList.index(after: currentBudgetIndex)
                    self.currentMonthBudget = self.budgetVM.budgetList[nextBudgetIndex]
                }
            }
        })
        
        
//        .fullScreenCover(isPresented: self.$askBiometrix, content: {
//            LoginView()
//        })
//        .fullScreenCover(isPresented: self.$askPasscode, content: {
//            PasscodeField(isNewPasscode: false)
//        })
        
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
    func setNavBarAppearance() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(CustomColors.TopBackgroundGradient3)
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray, .strokeColor: UIColor.clear, .underlineColor: UIColor.clear]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gray]
        coloredNavAppearance.shadowColor = .clear
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



//
//  ContentView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userSettingsVM) var userSettingsVM
    @ObservedObject var budgetVM = BudgetVM()
    @State var offsetY: CGFloat = 0.0
    @State var incomeSelected = false
    @State var savingsSelected = false
    @State var plusButtonColor = GradientColors.Expense
    @State var plusButtonIsServing = Categories.Expense
    @State var isBudgetView = true
    @State var isAnalyticsView = false
    @State var isSettingsView = false
    @State var showAddExpense: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader() { geo in
                Group {
                    if isSettingsView {
                        SettingsView()
                            .environment(\.userSettingsVM, userSettingsVM)
                            
                    } else if isAnalyticsView {
                        AnalyticsView()
                            
                    } else {
                        if let currentBudget = budgetVM.budgetList.last {
                            BudgetView(currentMonthBudget: .constant(currentBudget) ,
                                       geo: geo,
                                       plusButtonColor: self.$plusButtonColor,
                                       plusButtonIsServing: self.$plusButtonIsServing)
                                .environmentObject(budgetVM)
                                
                        }
                        
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .overlay(

                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("TopGradient"), Color.white]), startPoint: .bottomLeading, endPoint: .topLeading))
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
        }
        .sheet(isPresented: self.$showAddExpense, content: {
            if let currentMonthBudget = budgetVM.budgetList.last {
                let addingCategory = getAddingCategory()
                AddTransactionView(currentMonthBudget: currentMonthBudget, category: addingCategory)
                    .environmentObject(self.budgetVM)
                    .environment(\.userSettingsVM, self.userSettingsVM)
            }
            
        })
        
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



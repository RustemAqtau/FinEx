//
//  AddExpense.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-14.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userSettingsVM) var userSettingsVM
    @Binding var currentMonthBudget: MonthlyBudget
    @State var category: String
    
    @State var amount: NSDecimalNumber = 0
    @State private var amountString: String = ""
    @State private var amountIsEditing: Bool = false
    @State var selectedtypeImageName: String = "questionmark"
    @State var selectedTypeCircleColor: String = "TopGradient"
    @State var selectedTypeName: String = NSLocalizedString("Category", comment: "")
    @State var selectedType: TransactionType = TransactionType()
    @State var showCategorySelector: Bool = false
    @State var selectedDate: Date = Date()
    @State var note: String = ""
    @State var noteLenghtLimitOut: Bool = false
    @State var dateRange: ClosedRange<Date> = getDateRange(for: Date())
    @State var showCalendar: Bool = false
    @State var accentColor: Color = CustomColors.ExpensesColor2
    @State var validationFailed: Bool = false
    @State var warningMessage: String = ""
    @State var amountPlaceholder: String = ""
    @State private var saveButtonOffsetY: CGFloat = 20
    @State private var balanceCheckFailed: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 30) {
                    VStack(spacing: 5) {
                        Text(LocalizedStringKey(warningMessage))
                            .font(Fonts.light12)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding()
                            .opacity(self.validationFailed ? 1 : 0)
                        ZStack {
                            RoundedRectangle(cornerRadius: 35.0)
                                .fill(Color.white)
                            RoundedRectangle(cornerRadius: 35.0)
                                .stroke(self.accentColor)
                            TextField(self.amountPlaceholder, text: self.$amountString, onEditingChanged: { isEditing in
                                if isEditing {
                                    self.amountIsEditing = true
                                    replaceSaveButton(down: false)
                                } else {
                                    hideKeyboard()
                                    self.amountIsEditing = false
                                }
                            })
                            .foregroundColor(self.balanceCheckFailed ? .red : CustomColors.TextDarkGray)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .cornerRadius(25)
                            .accentColor(CustomColors.TextDarkGray)
                            .introspectTextField { textField in
                                textField.becomeFirstResponder()
                                textField.textAlignment = NSTextAlignment.center
                            }
                            .font(Font.system(size: 30, weight: .light, design: .default))
                            .keyboardType(.decimalPad)
                         }
                        .frame(width: geo.size.width * 0.60, height: 60, alignment: .center)
                    }
                    
                    
                    Divider()
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .stroke(self.accentColor)
                                    .frame(width: 43, height: 43, alignment: .center)
                                    .opacity(self.selectedTypeName == Placeholders.NewCategorySelector.localizedString() ? 1 : 0)
                                Image(self.selectedtypeImageName)
                                    .foregroundColor(.white)
                                    .modifier(CircleModifierSimpleColor(color: Color(self.selectedTypeCircleColor), strokeLineWidth: 3.0))
                                    .font(Font.system(size: 22, weight: .regular, design: .default))
                                    .frame(width: 43, height: 43, alignment: .center)
                            }
                            Text(LocalizedStringKey(self.selectedTypeName))
                                .font(Font.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(CustomColors.TextDarkGray)
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        .onTapGesture {
                            self.showCategorySelector = true
                        }
                        
                        HStack(spacing: 15) {
                            Image(systemName: "calendar")
                                .foregroundColor(self.accentColor)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                                .onTapGesture {
                                    self.showCalendar = true
                                }
                            DatePicker("Label", selection: self.$selectedDate,
                                            in: dateRange,
                                            displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.clear)
                                .foregroundColor(CustomColors.TextDarkGray)
                                .accentColor(CustomColors.TextDarkGray)
                                .shadow(radius: 10.0 )
                                
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        HStack(spacing: 25) {
                            Image(systemName: "pencil")
                                .foregroundColor(self.accentColor)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            TextField(LocalizedStringKey(Placeholders.Note.localizedString()), text: self.$note,
                                      onEditingChanged: {isEditing in if isEditing {
                                        
                                        replaceSaveButton(down: false)
                                        if !self.note.isEmpty {
                                            //self.note = ""
                                        }
                                        self.noteLenghtLimitOut = false
                                        
                                      } else {
                                        hideKeyboard()
                                        if self.note.count > 10 {
                                          self.noteLenghtLimitOut = true
                                            // TODO: Warning label
                                        }
                                      }
                            
                                      } , onCommit:  {
                                        
                                      })
                            .foregroundColor(self.noteLenghtLimitOut ? .red : CustomColors.TextDarkGray)
                                .font(Font.system(size: 16, weight: .light, design: .default))
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        Button(action: {
                            if validationSucceed() {
                                saveTransaction()
                            }
                        }) {
                            SaveButtonView(geo: geo, withTrash: false, withdraw: false)
                        }
                        //.offset(y: self.saveButtonOffsetY)
                        //.offset(y: -self.keyboardHeightHelper.keyboardHeight)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .ignoresSafeArea(.all, edges: .bottom)
                
            }
            .background(CustomColors.White_Background)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                    .font(Font.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(CustomColors.TextDarkGray)
            })
            .navigationBarTitle (Text(""), displayMode: .inline)
        }
        .onAppear {
            self.showCategorySelector = false
            switch category {
            case Categories.Income:
                self.accentColor = CustomColors.IncomeGradient1
            case Categories.Expense:
                self.accentColor = CustomColors.ExpensesColor2
            case Categories.Saving:
                self.accentColor = CustomColors.SavingsGradient1
            default: self.accentColor = CustomColors.ExpensesColor2
            }
            self.amountPlaceholder = userSettingsVM.settings.currencySymbol!
            self.dateRange = getDateRange(for: self.currentMonthBudget.startDate ?? Date())
            if let initialMonthbudget = self.budgetVM.budgetList.filter({ $0.isInitialMonth == true}).first {
                if self.currentMonthBudget.startDate! < initialMonthbudget.startDate! {
                    self.selectedDate = self.dateRange.lowerBound
                }
            }
            
        }
        .onTapGesture {
            hideKeyboard()
            self.amountIsEditing = false
            replaceSaveButton(down: true)
        }
        .sheet(isPresented: self.$showCategorySelector, content: {
            CategotySelector(category: self.category,
                             selectedType: self.$selectedType,
                             selectedtypeImageName: self.$selectedtypeImageName,
                             selectedTypeCircleColor: self.$selectedTypeCircleColor,
                             selectedTypeName: self.$selectedTypeName)
        })
        .onChange(of: self.selectedtypeImageName, perform: { value in
            validationFailed = false
        })
        .onChange(of: self.amountString, perform: { value in
            validationFailed = false
        })
        
    }
    
    private func saveTransaction() {
        let locale = Locale.current
        self.amount = NSDecimalNumber(string: self.amountString, locale: locale)
        print(self.amount)
        let newTransactionInfo = TransactionInfo(
            amount: self.amount,
            date: self.selectedDate,
            typeInfo: self.selectedType,
            note: self.note
        )
        budgetVM.addNewTransaction(
            info: newTransactionInfo,
            monthlyBudget: self.currentMonthBudget,
            context: viewContext
        )
        budgetVM.getTransactions(context: viewContext)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func validationSucceed() -> Bool {
        guard !self.amountString.isEmpty,
              !Double(truncating: NSDecimalNumber(string: self.amountString)).isNaN
        else {
            self.validationFailed = true
            self.balanceCheckFailed = true
            self.warningMessage = WarningMessages.ValidationAmountFail.localizedString()
            return false
        }
        if category == Categories.Saving {
            guard checkBalanceSucceed() else {
                self.validationFailed = true
                self.warningMessage = WarningMessages.CheckBalance.localizedString()
                return false
            }
        }
        guard self.selectedTypeName != Placeholders.NewCategorySelector.localizedString() else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.ValidationCategoryNotSelectedFail.localizedString()
            return false
        }
        return true
    }
    
    private func checkBalanceSucceed() -> Bool {
        let locale = Locale.current
        let amount = NSDecimalNumber(string: self.amountString, locale: locale)
        if self.currentMonthBudget.currentBalance >= amount as Decimal {
            return true
        }
        self.balanceCheckFailed = true
        return false
    }
    
    private func replaceSaveButton(down: Bool) {
        
        withAnimation(.easeInOut(duration: 0.5)) {
            self.saveButtonOffsetY = down ? self.keyboardHeightHelper.keyboardHeight  : -self.keyboardHeightHelper.keyboardHeight
        }
        
    }
}



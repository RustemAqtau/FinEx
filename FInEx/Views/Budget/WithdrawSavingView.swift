//
//  WithdrawSavingView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-30.
//

import SwiftUI

struct WithdrawSavingView: View {
    @EnvironmentObject var budgetVM: BudgetManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userSettingsVM) var userSettingsVM
    @Binding var currentMonthBudget: MonthlyBudget
    @Binding var savingsType: TransactionType
    
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
    
    @State private var accentColor: Color = CustomColors.SavingsGradient1
    @State private var validationFailed: Bool = false
    @State private var balanceCheckFailed: Bool = false
    @State private var warningMessage: String = ""
    @State private var amountPlaceholder: String = ""
    
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
                        .opacity(0.8)
                        
                        HStack(spacing: 15) {
                            Image(systemName: "calendar")
                                .foregroundColor(self.accentColor)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            Text(setDate(date: self.selectedDate))
                                .opacity(0.6)
                         }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        .opacity(0.8)
                        HStack(spacing: 25) {
                            Image(systemName: "pencil")
                                .foregroundColor(self.accentColor)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            TextField(LocalizedStringKey("Note"), text: self.$note,
                                      onEditingChanged: {isEditing in if isEditing {
                                        if !self.note.isEmpty {
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
                            SaveButtonView(geo: geo, withTrash: false, withdraw: true)
                        }
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
            .onAppear {
                
                self.selectedType = self.savingsType
                self.selectedTypeName = self.savingsType.presentingName
                self.selectedtypeImageName = self.savingsType.presentingImageName
                self.selectedTypeCircleColor = self.savingsType.presentingColorName
                self.amountPlaceholder = userSettingsVM.settings.currencySymbol!
            }
        }
    }
    
    private func saveTransaction() {
        let locale = Locale.current
        var decimal = NSDecimalNumber(string: self.amountString, locale: locale).decimalValue
        decimal.negate()
        self.amount = NSDecimalNumber(decimal: decimal)
        print("negativeAmount = \(self.amount)")
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
        
        guard checkBalanceSucceed() else {
            self.validationFailed = true
            self.warningMessage = WarningMessages.CheckBalance.localizedString()
            return false
        }
        
        return true
    }
    
    private func checkBalanceSucceed() -> Bool {
        let locale = Locale.current
        let amount = NSDecimalNumber(string: self.amountString, locale: locale)
        if (self.currentMonthBudget.savingsTotalAmountByType[self.savingsType] ?? 0) >= amount as Decimal {
            return true
        }
        self.balanceCheckFailed = true
        return false
    }
}



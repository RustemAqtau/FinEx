//
//  SetRecurringTransactionView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-18.
//

import SwiftUI

struct SetRecurringTransactionView: View {
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var category: String
    
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
    @State var selectedPeriodicity: String = Periodicity.Month.localizedString()
    @State var periodicityList: [String] = []
    @State var dateRange: ClosedRange<Date>  = getDateRange(for: Date())
    @State var showCalendar: Bool = false
    @State var dayWeekOfMonth: String = ""
    @State var savingFailed: Bool = false
    @State var amountPlaceholder: String = ""
    @State var validationFailed: Bool = false
    @State var warningMessage: String = ""
    @State var categoryValidationFailed: Bool = false
    @State var amountValidationFailed: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 20) {
                    
                    VStack {
                        Text(LocalizedStringKey(self.warningMessage))
                            .font(Fonts.light12)
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .opacity(self.validationFailed ? 1 : 0)
                            .padding(.horizontal)
                            .frame(width: geo.size.width * 0.90, alignment: .center)
                        ZStack {
                            RoundedRectangle(cornerRadius: 35.0)
                                .fill(Color.white)
                               // .opacity(self.amountIsEditing ? 1 : 0)
                            RoundedRectangle(cornerRadius: 35.0)
                                .stroke(Color.gray)
                                //.opacity(self.amountIsEditing ? 1 : 0)
                            TextField(self.amountPlaceholder, text: self.$amountString, onEditingChanged: { isEditing in
                                if isEditing {
                                    self.amountIsEditing = true
                                } else {
                                    hideKeyboard()
                                    self.amountIsEditing = false
                                   // hideKeyboard()
                                }
                            })
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .cornerRadius(25)
                            .accentColor(CustomColors.TextDarkGray)
                            .introspectTextField { textField in
                                
                                textField.textAlignment = NSTextAlignment.center
                                if !self.amountIsEditing {
                                    textField.resignFirstResponder()
                                } else {
                                    textField.becomeFirstResponder()
                                }
                            }
                            .font(Font.system(size: 30, weight: .light, design: .default))
                            .foregroundColor(self.amountValidationFailed ? .red : CustomColors.TextDarkGray)
                            .keyboardType(.decimalPad)
                            .padding()
                            
                        }
                        .frame(width: geo.size.width * 0.60, height: 60, alignment: .center)
                    }
                    .frame(width: geo.size.width * 0.90, height: 100, alignment: .center)
                    
                    Divider()
                    
                    VStack(spacing: 10) {
                        
                        HStack(spacing: 15) {
                            Image(systemName: self.selectedtypeImageName)
                                .foregroundColor(.white)
                                .modifier(CircleModifierSimpleColor(color: Color(self.selectedTypeCircleColor), strokeLineWidth: 3.0))
                                .font(Font.system(size: 22, weight: .regular, design: .default))
                                .frame(width: 45, height: 45, alignment: .center)
                                
                            Text(LocalizedStringKey(self.selectedTypeName))
                                .font(Font.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(self.categoryValidationFailed ? Color.red : CustomColors.TextDarkGray)
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        .onTapGesture {
                            //hideKeyboard()
                            self.showCategorySelector = true
                        }
                        
                        HStack(spacing: 15) {
                            Image(systemName: "calendar")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                                .onTapGesture {
                                    self.showCalendar = true
                                }
                            DatePicker(LocalizedStringKey(LableTitles.startDate.localizedString()), selection: self.$selectedDate,
                                            in: dateRange,
                                            displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.clear)
                                .foregroundColor(CustomColors.TextDarkGray)
                                .accentColor(CustomColors.TextDarkGray)
                                .shadow(radius: 10.0 )
                                
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        //.padding()
                        
                        HStack(spacing: 15) {
                            Image(systemName: "clock.arrow.2.circlepath")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            
                            Picker(NSLocalizedString(self.selectedPeriodicity, comment: "") + self.dayWeekOfMonth,
                                   selection: self.$selectedPeriodicity) {
                                ForEach(self.periodicityList.sorted(), id: \.self) { periodicity in
                                    Text(LocalizedStringKey(periodicity))
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .multilineTextAlignment(.center)
                            .frame(width: geo.size.width * 0.65, alignment: .leading)
                            
                        }
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        
                        HStack(spacing: 25) {
                            Image(systemName: "pencil")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            TextField(LocalizedStringKey(Placeholders.Note.localizedString()), text: self.$note,
                                      onEditingChanged: {isEditing in if isEditing {
                                        
                                        self.noteLenghtLimitOut = false
                                        
                                      } else {
                                        //hideKeyboard()
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
                        .frame(width: geo.size.width * 0.90, alignment: .leading)
                        Button(action: {
                          //  hideKeyboard()
                            if validationSucceed() {
                                saveTransaction()
                            }
                           
                        }) {
                            SaveButtonView(geo: geo, withTrash: false, withdraw: false)
                        }
                        //.offset(y: -self.keyboardHeightHelper.keyboardHeight)
                    }
                    
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .ignoresSafeArea(.all, edges: .bottom)
                
            }
            
            .onAppear {
                self.selectedDate = getFirstDayOfmonth(date: Date())
                self.dateRange = getDateRange(for: self.selectedDate)
                var periodicityArray: [String] = []
                for elem in Periodicity.allCases {
                    periodicityArray.append(elem.rawValue)
                }
                self.periodicityList = periodicityArray
                self.amountPlaceholder = userSettingsVM.settings.currencySymbol!
            }
            .onChange(of: self.selectedPeriodicity, perform: { value in
                updatePeriodicityText()
                
             })
            .onChange(of: self.selectedDate, perform: { value in
                updatePeriodicityText()
            })
            .sheet(isPresented: self.$showCategorySelector, content: {
                CategotySelector(category: self.category,
                                 selectedType: self.$selectedType,
                                 selectedtypeImageName: self.$selectedtypeImageName,
                                 selectedTypeCircleColor: self.$selectedTypeCircleColor,
                                 selectedTypeName: self.$selectedTypeName)
            })
            .navigationBarItems(leading: Button(action: {
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(Font.system(size: 20, weight: .regular, design: .default))
            })
            .navigationBarTitle (Text(""), displayMode: .inline)
            .onChange(of: self.selectedtypeImageName, perform: { value in
                validationFailed = false
                self.amountValidationFailed = false
                self.categoryValidationFailed = false
            })
            .onChange(of: self.amountString, perform: { value in
                validationFailed = false
                self.amountValidationFailed = false
                self.categoryValidationFailed = false
            })
//            .onChange(of: self.showCategorySelector, perform: { value in
//                hideKeyboard()
//            })
        }
        .onTapGesture {
            hideKeyboard()
        }
        .accentColor(CustomColors.TextDarkGray)
        .background(CustomColors.White_Background)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func updatePeriodicityText() {
        let format = DateFormatter()
        format.locale = .current
        
        switch self.selectedPeriodicity {
        case Periodicity.Month.rawValue, Periodicity.Quarter.rawValue:
            format.dateFormat = "d"
            let dateString = NSLocalizedString(SettingsContentDescription.reminderTab_field2_pickerLabel.localizedString(), comment: "") + " " + format.string(from: self.selectedDate)
            self.dayWeekOfMonth = ", " + dateString
        case Periodicity.TwoWeeks.rawValue:
            format.dateFormat = "EEEE"
            let dateString = format.string(from: self.selectedDate)
            self.dayWeekOfMonth = ", " + dateString
        default:
            format.dateFormat = "d"
            let dateString = NSLocalizedString(SettingsContentDescription.reminderTab_field2_pickerLabel.localizedString(), comment: "") + " " + format.string(from: self.selectedDate)
            self.dayWeekOfMonth = ", " + dateString
        }
    }
    
    private func saveTransaction() {
            let locale = Locale.current
            self.amount = NSDecimalNumber(string: self.amountString, locale: locale)
      
            let newRecurringTransactionInfo = RecurringTransactionInfo(
                startDate: self.selectedDate,
                nextAddingDate: self.selectedDate,
                amount: self.amount,
                note: self.note,
                periodicity: self.selectedPeriodicity,
                type: self.selectedType,
                category: self.category)
            
            userSettingsVM.addNewRecurringTransaction(info: newRecurringTransactionInfo, context: viewContext)
            presentationMode.wrappedValue.dismiss()
        
    }
    private func validationSucceed() -> Bool {
        guard !self.amountString.isEmpty,
              !Double(truncating: NSDecimalNumber(string: self.amountString)).isNaN
        else {
            self.validationFailed = true
            self.amountValidationFailed = true
            self.warningMessage = WarningMessages.ValidationAmountFail.localizedString()
            return false
            
        }
        guard self.selectedTypeName != Placeholders.NewCategorySelector.localizedString() else {
            self.validationFailed = true
            self.categoryValidationFailed = true
            self.warningMessage = WarningMessages.ValidationCategoryNotSelectedFail.localizedString()
            return false
        }
        userSettingsVM.getRecurringTransactions(context: viewContext)
        guard !userSettingsVM.recurringTransactions.contains(where: { transaction in transaction.type == self.selectedType }) else {
            self.validationFailed = true
            self.categoryValidationFailed = true
            self.warningMessage = WarningMessages.ExistingCategory.localizedString()
            return false
        }
        return true
    }
    
    
}

struct SetRecurringTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        SetRecurringTransactionView(category: .constant((Categories.Expense)))
    }
}

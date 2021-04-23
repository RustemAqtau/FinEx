//
//  SetRecurringTransactionView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-18.
//

import SwiftUI

struct SetRecurringTransactionView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var category: String
    
    @State var amount: NSDecimalNumber = 0
    @State private var amountString: String = ""
    @State private var amountIsEditing: Bool = false
    @State var selectedtypeImageName: String = "questionmark"
    @State var selectedTypeCircleColor: String = "TopGradient"
    @State var selectedTypeName: String = "Category"
    @State var selectedType: TransactionType = TransactionType()
    @State var showCategorySelector: Bool = false
    @State var selectedDate: Date = Date()
    //@State var nextAddingDate: Date = Date()
    @State var note: String = "Note"
    @State var noteLenghtLimitOut: Bool = false
    @State var selectedPeriodicity: String = Periodicity.Month.rawValue
    @State var periodicityList: [String] = []
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let startComponents = DateComponents(year: year, month: month, day: 1)
        let endComponents = DateComponents(year: year, month: month, day: 30)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    @State var showCalendar: Bool = false
    @State var dayWeekOfMonth: String = ""
    @State var savingFailed: Bool = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 30) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 35.0)
                            .fill(Color.white)
                            .opacity(self.amountIsEditing ? 1 : 0)
                        RoundedRectangle(cornerRadius: 35.0)
                            .stroke(Color.gray)
                            //.shadow(radius: 5.0 )
                            .opacity(self.amountIsEditing ? 1 : 0)
                        TextField("$", text: self.$amountString, onEditingChanged: { isEditing in
                            
                            if isEditing {
                                self.amountIsEditing = true
                                self.amountString = ""
                            } else {
                                self.amountIsEditing = false
                                
                            }
                        })
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
                        .padding()
                        
                    }
                    .frame(width: geo.size.width / 1.5, height: 60, alignment: .center)
                    
                    Divider()
                    
                    VStack(spacing: 15) {
                        Text("You have already added a recurring for this categoty, please change category.")
                            .font(Font.system(size: 10, weight: .light, design: .default))
                            .foregroundColor(Color.gray)
                            .opacity(self.savingFailed ? 1 : 0)
                        HStack(spacing: 15) {
                            Image(systemName: self.selectedtypeImageName)
                                .foregroundColor(.white)
                                .modifier(CircleModifierSimpleColor(color: Color(self.selectedTypeCircleColor), strokeLineWidth: 3.0))
                                .font(Font.system(size: 22, weight: .regular, design: .default))
                                .frame(width: 45, height: 45, alignment: .center)
                                
                            Text(self.selectedTypeName)
                                .font(Font.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(self.savingFailed ? Color.red : CustomColors.TextDarkGray)
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        .onTapGesture {
                            self.showCategorySelector = true
                        }
                        
                        HStack(spacing: 15) {
                            Image(systemName: "calendar")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                                .onTapGesture {
                                    self.showCalendar = true
                                }
                            DatePicker("Start Day", selection: self.$selectedDate,
                                            in: dateRange,
                                            displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.clear)
                                .foregroundColor(CustomColors.TextDarkGray)
                                .accentColor(CustomColors.TextDarkGray)
                                .shadow(radius: 10.0 )
                                
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        //.padding()
                        
                        HStack(spacing: 15) {
                            Image(systemName: "clock.arrow.2.circlepath")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            
                            Picker(self.selectedPeriodicity + self.dayWeekOfMonth,
                                   selection: self.$selectedPeriodicity) {
                                ForEach(self.periodicityList, id: \.self) { periodicity in
                                    Text(periodicity)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .multilineTextAlignment(.center)
                            .frame(width: geo.size.width * 0.65, alignment: .leading)
                            
                        }
                        .frame(width: geo.size.width * 0.80, alignment: .leading)
                        
                        HStack(spacing: 25) {
                            Image(systemName: "pencil")
                                .foregroundColor(CustomColors.TextDarkGray)
                                .font(Font.system(size: 30, weight: .regular, design: .default))
                            TextField(self.note, text: self.$note,
                                      onEditingChanged: {isEditing in if isEditing {
                                        if !self.note.isEmpty {
                                            self.note = ""
                                        }
                                        self.noteLenghtLimitOut = false
                                        
                                      } else {
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
                        
                    }
                    Button(action: {
                       saveTransaction()
                    }) {
                        SaveButtonView(geo: geo, withTrash: false)
                    }
                    
                }
                
            }
            .onAppear {
                var periodicityArray: [String] = []
                for elem in Periodicity.allCases {
                    periodicityArray.append(elem.rawValue)
                }
                self.periodicityList = periodicityArray
            }
            .onChange(of: self.selectedPeriodicity, perform: { value in
                let format = DateFormatter()
                format.locale = .current
                var dateString: String = ""
                switch self.selectedPeriodicity {
                case Periodicity.Month.rawValue, Periodicity.Quarter.rawValue:
                    format.dateFormat = "dd"
                    dateString = "day " + format.string(from: self.selectedDate)
                case Periodicity.TwoWeeks.rawValue:
                    format.dateFormat = "EEEE"
                    dateString = format.string(from: self.selectedDate)
                default:
                    format.dateFormat = "MMM-dd"
                    dateString = format.string(from: self.selectedDate)
                }
                
                self.dayWeekOfMonth = ", " + dateString
                
            })
            .sheet(isPresented: self.$showCategorySelector, content: {
                CategotySelector(categoty: self.category,
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
        }
    }
    func saveTransaction() {
        userSettingsVM.getRecurringTransactions(context: viewContext)
        if !userSettingsVM.recurringTransactions.contains(where: { transaction in transaction.type == self.selectedType }) {
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
            userSettingsVM.getRecurringTransactions(context: viewContext)
            presentationMode.wrappedValue.dismiss()
        } else {
            // show Warning
            self.savingFailed = true
        }
       
    }
    
}

struct SetRecurringTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        SetRecurringTransactionView(category: .constant((Categories.Expense)))
    }
}

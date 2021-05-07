//
//  AppearanceView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-26.
//

import SwiftUI

struct AppearanceView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedCurrencySymbol: String = ""
    @State var currencyName: String = ""
    @State var showDecimals: Bool = false
    @Binding var  hideTabBar: Bool
    @Binding var themeColorChanged: Bool
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {

                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, height: 80, alignment: .leading)
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(NSLocalizedString(SettingsContentDescription.appearanceTab_field1_title.localizedString(), comment: "").uppercased())
                                            .font(Fonts.light12)
                                            .foregroundColor(CustomColors.TextDarkGray)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 25.0)
                                                .stroke(Color.red)
                                            Picker(LocalizedStringKey("CHANGE"),
                                                   selection: self.$selectedCurrencySymbol) {
                                                ForEach(CurrencySymbols.allCases, id: \.self) { symbol in
                                                    Text(LocalizedStringKey(symbol.rawValue)).tag(symbol.rawValue)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .font(Font.system(size: 12, weight: .light, design: .default))
                                            .foregroundColor(CustomColors.TextDarkGray)
                                        }
                                        .frame(width: geo.size.width / 4, height: 20, alignment: .center)
                                    }
                                    
                                    HStack {
                                        Text(self.selectedCurrencySymbol)
                                            .modifier(CircleModifier(color: GradientColors.Home, strokeLineWidth: 2))
                                            .foregroundColor(.white)
                                            .font(Font.system(size: 20, weight: .regular, design: .default))
                                            .frame(width: geo.size.width / 12, height: geo.size.width / 11, alignment: .center)
                                        Text(LocalizedStringKey(self.currencyName))
                                            .foregroundColor(CustomColors.TextDarkGray)
                                            .font(Fonts.light20)
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .frame(width: geo.size.width, height: 50, alignment: .leading)
                        }
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, height: 80, alignment: .leading)
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(NSLocalizedString(SettingsContentDescription.appearanceTab_field2_title.localizedString(), comment: "").uppercased())
                                        .font(Fonts.light12)
                                        .foregroundColor(CustomColors.TextDarkGray)
                                    Toggle(isOn: self.$showDecimals, label: {
                                        HStack {
                                            Text(NSLocalizedString(SettingsContentDescription.appearanceTab_field2.localizedString(), comment: ""))
                                                .foregroundColor(CustomColors.TextDarkGray)
                                                .multilineTextAlignment(.leading)
                                                .font(Font.system(size: 18, weight: .light, design: .default))
                                                .lineLimit(2)
                                        }
                                    })
                                }
                            }
                            .padding(.horizontal)
                            .frame(width: geo.size.width, height: 50, alignment: .leading)
                        }
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .frame(width: geo.size.width, height: 80, alignment: .leading)
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(NSLocalizedString(SettingsContentDescription.appearanceTab_field3_title.localizedString(), comment: "").uppercased())
                                            .font(Fonts.light12)
                                    }
                                    .foregroundColor(CustomColors.TextDarkGray)
                                    HStack {
                                        ForEach(Theme.colors.keys.sorted(), id: \.self) { theme in
                                            ZStack {
                                                Circle()
                                                    .stroke(CustomColors.TextDarkGray)
                                                    .frame(width: geo.size.width / 10.5, height: geo.size.width / 10.5, alignment: .center)
                                                    .opacity(theme == userSettingsVM.settings.colorTheme ? 1 : 0)
                                                Text("")
                                                    .modifier(CircleModifier(color: Theme.colors[theme]!, strokeLineWidth: 2))
                                                    .frame(width: geo.size.width / 11, height: geo.size.width / 11, alignment: .center)
                                                    .onTapGesture {
                                                        
                                                        self.userSettingsVM.settings.editColorTheme(value: theme, context: viewContext)
                                                        self.themeColorChanged.toggle()
                                                    }
                                            }
                                            .onDisappear {
                                                self.hideTabBar = false
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .frame(width: geo.size.width, height: 50, alignment: .leading)
                        }
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                    .navigationBarTitle (Text(""), displayMode: .inline)
                    .onAppear{
                        self.hideTabBar = true
                        if let symbol = userSettingsVM.settings.currencySymbol {
                            self.selectedCurrencySymbol = symbol
                            setCurrencyName()
                        }
                        
                        self.showDecimals = self.userSettingsVM.settings.showDecimals
                    }
                    .onChange(of: self.selectedCurrencySymbol, perform: { value in
                        self.hideTabBar = true
                        userSettingsVM.settings.editCurrencySymbol(value: value, context: viewContext)
                        setCurrencyName()
                    })
                    .onChange(of: self.showDecimals, perform: { value in
                        self.hideTabBar = true
                        self.userSettingsVM.settings.editShowDecimals(value: value, context: viewContext)
                    })
                    .onChange(of: self.userSettingsVM.settings.colorTheme, perform: { value in
                        self.hideTabBar = true
                    })
                }
                .ignoresSafeArea(.all, edges: .bottom)

            }
        }
        
    }
    private func setCurrencyName() {
        switch self.selectedCurrencySymbol {
        case CurrencySymbols.dollar.rawValue: self.currencyName = Currencies.dollar.rawValue
        case CurrencySymbols.euro.rawValue: self.currencyName = Currencies.euro.rawValue
        case CurrencySymbols.lira.rawValue: self.currencyName = Currencies.lira.rawValue
        case CurrencySymbols.pound.rawValue: self.currencyName = Currencies.pound.rawValue
        case CurrencySymbols.ruble.rawValue: self.currencyName = Currencies.ruble.rawValue
        case CurrencySymbols.tenge.rawValue: self.currencyName = Currencies.tenge.rawValue
        case CurrencySymbols.yen.rawValue: self.currencyName = Currencies.yen.rawValue
        default: self.currencyName = Currencies.currency.rawValue
        }
    }
}

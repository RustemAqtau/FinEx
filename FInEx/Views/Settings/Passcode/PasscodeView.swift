//
//  PasscodeView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-17.
//

import SwiftUI


struct PasscodeView: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @State var enablePasscode: Bool = false
    @State var enableBiometrix: Bool = false
    @State var showSheet: Bool = false
    @Binding var  hideTabBar: Bool
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .shadow(radius: 5)
                            .frame(width: geo.size.width, height: geo.size.height / 3.5, alignment: .leading)
                        VStack {
                            Text(LocalizedStringKey(SettingsContentDescription.passcodeTab_description1.localizedString()))
                                .multilineTextAlignment(.leading)
                                .font(Fonts.light15)
                                .lineLimit(2)
                                
                            Divider()
                                .frame(width: geo.size.width * 0.90)
                            HStack(alignment: .center) {
                                Toggle(isOn: self.$enablePasscode, label: {
                                    Text(LocalizedStringKey(SettingsContentDescription.passcodeTab_field1.localizedString()))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .font(Fonts.light15)
                                })
                            }
                            .frame(width: geo.size.width * 0.90, alignment: .leading)
                            HStack(alignment: .center) {
                                Toggle(isOn: self.$enableBiometrix, label: {
                                    Text(LocalizedStringKey(SettingsContentDescription.passcodeTab_field2.localizedString()))
                                        .foregroundColor(CustomColors.TextDarkGray)
                                        .font(Fonts.light15)
                                })
                            }
                            .frame(width: geo.size.width * 0.90, alignment: .leading)
                        }
                        .font(Font.system(size: 18, weight: .light, design: .default))
                        .foregroundColor(CustomColors.TextDarkGray)
                        .padding()
                        .onDisappear {
                            self.hideTabBar = false
                        }
                    }
                    
                    .navigationBarTitle (Text(""), displayMode: .inline)
                    .frame(width: geo.size.width, alignment: .top)
                    .onAppear {
                        self.hideTabBar = true
                        self.enablePasscode = userSettingsVM.settings.isSetPassCode
                        self.enableBiometrix = userSettingsVM.settings.isSetBiometrix
                    }
                    .onChange(of: self.enablePasscode, perform: { value in
                        self.hideTabBar = true
                        if self.enablePasscode {
                            showSheet = true
                        }
                        userSettingsVM.settings.editIsSetPassCode(value: self.enablePasscode, context: viewContext)
                    })
                    .onChange(of: self.enableBiometrix, perform: { value in
                        self.hideTabBar = true
                        userSettingsVM.settings.editIsSetBiometrix(value: self.enableBiometrix, context: viewContext)
                    })
                    .fullScreenCover(isPresented: self.$showSheet, content: {
                        PasscodeField(isNewPasscode: true, askBiometrix: false)
                    })
//                    .sheet(isPresented: self.$showSheet, content: {
//                        PasscodeField(isNewPasscode: true, askBiometrix: false)
//                    })
                }
                
            }
            .background(CustomColors.White_Background)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}


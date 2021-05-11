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
    @Environment(\.presentationMode) var presentationMode
    @State var enablePasscode: Bool = false
    @State var enableBiometrics: Bool = false
    @State var showSheet: Bool = false
    @Binding var  hideTabBar: Bool
    var body: some View {
        
        GeometryReader { geo in
            VStack {
            }
            .frame(width: geo.size.width, height: geo.size.height / 8, alignment: .center)
            .background(Color.white)
            .ignoresSafeArea(.all, edges: .top)
            .zIndex(100)
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
                            .lineLimit(3)
                        
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
                            Toggle(isOn: self.$enableBiometrics, label: {
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
                    
                }
                
                .navigationBarTitle (Text(""), displayMode: .inline)
                .frame(width: geo.size.width, height: 80, alignment: .top)
                .onAppear {
                    self.hideTabBar = true
                    self.enablePasscode = userSettingsVM.settings.isSetPassCode
                    self.enableBiometrics = userSettingsVM.settings.isSetBiometrix
                }
                .onChange(of: self.enablePasscode, perform: { value in
                    
                    if self.enablePasscode && userSettingsVM.settings.isSetPassCode == false {
                        showSheet = true
                    }
                    userSettingsVM.settings.editIsSetPassCode(value: self.enablePasscode, context: viewContext)
                })
                .onChange(of: self.enableBiometrics, perform: { value in
                    
                    userSettingsVM.settings.editIsSetBiometrics(value: self.enableBiometrics, context: viewContext)
                })
                .fullScreenCover(isPresented: self.$showSheet, content: {
                    PasscodeField(isNewPasscode: true, askBiometrix: false)
                })
                
            }
            
        }
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
        
    }
}


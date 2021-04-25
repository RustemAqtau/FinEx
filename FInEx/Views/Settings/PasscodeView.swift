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
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    Text(LocalizedStringKey("Protect your data with a passcode. This way only you can enter and access your information."))
                        .multilineTextAlignment(.leading)
                    Divider()
                        .frame(width: geo.size.width * 0.90)
                    HStack(alignment: .center) {
                        Toggle(isOn: self.$enablePasscode, label: {
                            Text(LocalizedStringKey("Enable Passcode"))
                        })
                    }
                    .frame(width: geo.size.width * 0.90, alignment: .leading)
                    HStack(alignment: .center) {
                        Toggle(isOn: self.$enableBiometrix, label: {
                            Text(LocalizedStringKey("Enable TouchID/FaceID"))
                        })
                    }
                    .frame(width: geo.size.width * 0.90, alignment: .leading)
                }
                .font(Font.system(size: 18, weight: .light, design: .default))
                .foregroundColor(CustomColors.TextDarkGray)
                .padding()
                .frame(width: geo.size.width * 0.90, alignment: .leading)
                .onAppear {
                    print("onAppear: \(self.enablePasscode)")
                    self.enablePasscode = userSettingsVM.settings.isSetPassCode
                    self.enableBiometrix = userSettingsVM.settings.isSetBiometrix
                }
                .onChange(of: self.enablePasscode, perform: { value in
                    print("onChange: \(self.enablePasscode)")
                    if self.enablePasscode {
                        showSheet = true
                    }
                    userSettingsVM.settings.changeIsSetPassCode(value: self.enablePasscode, context: viewContext)
                })
                .onChange(of: self.enableBiometrix, perform: { value in
                    userSettingsVM.settings.changeIsSetBiometrix(value: self.enableBiometrix, context: viewContext)
                })
//                .fullScreenCover(isPresented: self.$showSheet, content: {
//                    PasscodeField(isNewPasscode: true)
//                })
                .sheet(isPresented: self.$showSheet, content: {
                    PasscodeField(isNewPasscode: true)
                })
            }
            
        }
    }
}

struct PasscodeView_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeView()
    }
}

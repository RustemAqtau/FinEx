//
//  RegisterWithAppleID.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-09.
//

import SwiftUI
import AuthenticationServices
import KeychainAccess

struct RegisterWithAppleID: View {
    @Environment(\.userSettingsVM) var userSettingsVM
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showSuccessView: Bool = false
    @Binding var  hideTabBar: Bool
    @State var isSigned: Bool = false
   
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(spacing: 5) {
                    Group {
                        VStack {
                            Image(systemName: self.isSigned ? Icons.iCloudCheckmark_Fill : Icons.iCloudLink_Fill)
                                .font(Font.system(size: 180, weight: .regular, design: .default))
                                .foregroundColor(CustomColors.CloudBlue)
                                
                            Text(LocalizedStringKey("Sync & Secure"))
                                .font(Font.system(size: 25, weight: .bold, design: .default))
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.30, alignment: .top)
                        
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(self.isSigned ? CustomColors.CloudBlue : .red)
                                .modifier(CircleModifierSimpleColor(color: CustomColors.TopColorGradient2, strokeLineWidth: 3.0))
                                .frame(width: 35, height: 35, alignment: .center)
                            Text(self.isSigned ? LocalizedStringKey("Your budget and transactions are synchronized between your devices.") : LocalizedStringKey("Sync budget and transactions between your devices."))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image(systemName: "icloud.and.arrow.up.fill")
                                .foregroundColor(self.isSigned ? CustomColors.CloudBlue : .red)
                                .modifier(CircleModifierSimpleColor(color: CustomColors.TopColorGradient2, strokeLineWidth: 3.0))
                                .frame(width: 35, height: 35, alignment: .center)
                            Text(self.isSigned ? LocalizedStringKey("Your data safely backed up on the cloud incase you lose/change your phone.") : LocalizedStringKey("Backup your data in case you lose/change your phone."))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(self.isSigned ? CustomColors.CloudBlue : .red)
                                .modifier(CircleModifierSimpleColor(color: CustomColors.TopColorGradient2, strokeLineWidth: 3.0))
                                .frame(width: 35, height: 35, alignment: .center)
                            Text(LocalizedStringKey("Dont worry, we will never send you any emails."))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .font(Fonts.light15)
                    .foregroundColor(CustomColors.TextDarkGray)
                    .padding()
                    .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.40, alignment: .center)
                    
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let keychain = Keychain(service: "zh.ayazbayeva.FInEx")
                                    .synchronizable(true)
                                    .accessibility(.afterFirstUnlock)
                                keychain[KeychainAccessKeys.AppleIDCredential] = appleIDCredential.user
                                userSettingsVM.settings.editIsSignedWithAppleId(value: true, context: viewContext)
                                self.showSuccessView = true
                                // TODO: - SuccessView
                                print("Authorisation successful")
                            default:
                                break
                            }
                                
                        case .failure(let error):
                                print("Authorisation failed: \(error.localizedDescription)")
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .cornerRadius(40.0)
                    .frame(width: 300, height: 55, alignment: .top)
                    .opacity(self.isSigned ? 0 : 1)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            .onAppear {
                self.hideTabBar = true
                self.isSigned = self.userSettingsVM.settings.isSignedWithAppleId
                print(self.userSettingsVM.settings.isSignedWithAppleId)
            }
            }
            .navigationBarTitle (Text(""), displayMode: .inline)
        }
    }
}



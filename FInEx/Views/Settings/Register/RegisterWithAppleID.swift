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
    @EnvironmentObject var userSettingsVM: UserSettingsManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var showSuccessView: Bool = false
    @Binding var  hideTabBar: Bool
    @State var isSigned: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
            }
            .frame(width: geo.size.width, height: geo.size.height / 8, alignment: .center)
            .background(Color.white)
            .ignoresSafeArea(.all, edges: .top)
            .zIndex(100)
            VStack(spacing: 5) {
                Group {
                    VStack {
                        Image(systemName: self.isSigned ? Icons.iCloudCheckmark_Fill : Icons.iCloudLink_Fill)
                            .font(Font.system(size: 180, weight: .regular, design: .default))
                            .foregroundColor(CustomColors.CloudBlue)
                        
                        Text(LocalizedStringKey(SettingsContentDescription.registerTab_title.localizedString()))
                            .font(Font.system(size: 25, weight: .bold, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundColor(CustomColors.TextDarkGray)
                    }
                    .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.30, alignment: .top)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(self.isSigned ? CustomColors.CloudBlue : .red)
                                .modifier(CircleModifierSimpleColor(color: CustomColors.TopColorGradient2, strokeLineWidth: 3.0))
                                .frame(width: 35, height: 35, alignment: .center)
                            Text(self.isSigned ? LocalizedStringKey(SettingsContentDescription.registerTab_description1_signed.localizedString()) : LocalizedStringKey(SettingsContentDescription.registerTab_description1.localizedString()))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(CustomColors.TextDarkGray)
                        }
                        HStack {
                            Image(systemName: "icloud.and.arrow.up.fill")
                                .foregroundColor(self.isSigned ? CustomColors.CloudBlue : .red)
                                .modifier(CircleModifierSimpleColor(color: CustomColors.TopColorGradient2, strokeLineWidth: 3.0))
                                .frame(width: 35, height: 35, alignment: .center)
                            Text(self.isSigned ? LocalizedStringKey(SettingsContentDescription.registerTab_description2_signed.localizedString()) : LocalizedStringKey(SettingsContentDescription.registerTab_description2.localizedString()))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(CustomColors.TextDarkGray)
                        }
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(self.isSigned ? CustomColors.CloudBlue : .red)
                                .modifier(CircleModifierSimpleColor(color: CustomColors.TopColorGradient2, strokeLineWidth: 3.0))
                                .frame(width: 35, height: 35, alignment: .center)
                            Text(LocalizedStringKey(SettingsContentDescription.registerTab_description3.localizedString()))
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(CustomColors.TextDarkGray)
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
                                let keychain = Keychain(service: KeychainAccessKeys.ServiceName)
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
                    .cornerRadius(80.0)
                    .frame(width: geo.size.width * 0.80, height: 60, alignment: .top)
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
        .background(CustomColors.White_Background)
        .navigationBarTitle (Text(""), displayMode: .inline)
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
        .ignoresSafeArea(.all, edges: .bottom)
        
        
    }
}



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
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showSuccessView: Bool = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(spacing: 20) {
                    Group {
                        Image(systemName: "link.icloud.fill")
                            .font(Font.system(size: 130, weight: .regular, design: .default))
                            .foregroundColor(Color("CloudBlue"))
                            
                        Text("Sync & Secure")
                            .font(Font.system(size: 35, weight: .bold, design: .default))
                    }
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.red)
                            .modifier(CircleModifier(color: Color("TopGradient"), strokeLineWidth: 3.0))
                            .frame(width: 35, height: 35, alignment: .center)
                        Text("Sync budgets and transactions between your devices.")
                    }
                    HStack {
                        Image(systemName: "icloud.and.arrow.up.fill")
                            .foregroundColor(.red)
                            .modifier(CircleModifier(color: Color("TopGradient"), strokeLineWidth: 3.0))
                            .frame(width: 35, height: 35, alignment: .center)
                        Text("Backup your data in case you lose your phone.")
                    }
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .modifier(CircleModifier(color: Color("TopGradient"), strokeLineWidth: 3.0))
                            .frame(width: 35, height: 35, alignment: .center)
                        Text("Dont worry, we;ll never send you any emails.")
                    }
                }
                .padding()
                .frame(width: geo.size.width * 0.80)
                
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
                            keychain["userIdentifierAppleIDCredential"] = appleIDCredential.user
                            userSettings.changeIsSignedWithAppleId(value: true, context: viewContext)
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
                .frame(width: 300, height: 60, alignment: .center)
            }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            
            }
        }
        
        
    }
}

struct RegisterWithAppleID_Previews: PreviewProvider {
    static var previews: some View {
        RegisterWithAppleID()
    }
}

//
//  LoginView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-24.
//

import SwiftUI
import KeychainAccess
import LocalAuthentication

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("")
            .onAppear {
                tryBiometricAuthentication()
            }
    }
    func tryBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to unlock InEx app."
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { authenticated, error in
                DispatchQueue.main.async {
                    if authenticated {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        if let errorString = error?.localizedDescription {
                            print("Error in biometric policy evaluation: \(errorString)")
                        }
                    }
                }
            }
        } else {
            if let errorString = error?.localizedDescription {
                print("Error in biometric policy evaluation: \(errorString)")
            }
            
        }
    }
}



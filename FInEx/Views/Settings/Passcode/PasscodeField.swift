//
//  PasscodeField.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-24.
//

import SwiftUI
import Introspect
import KeychainAccess
import LocalAuthentication

public struct PasscodeField: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isNewPasscode: Bool
    @State var showResetButton :Bool = false
    @State var askBiometrix: Bool
    
    var maxDigits: Int = 4
    @State var pin: String = ""
    @State var showPin = false
    @State var isDisabled = false
    @State var textColor = Color.black
    
  //  var handler: (String, (Bool) -> Void) -> Void
    
    public var body: some View {
        let label = self.isNewPasscode ?  "Enter New Passcode" : "Enter Passcode"
        VStack(spacing: 20) {
            Text(label).font(.title)
            ZStack {
                pinDots
                backgroundField
            }
            showPinStack
            Button(action: {
                resetPasscode()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 45)
                        .fill(Color.black)
                        .shadow(radius: 3)
                    Text(LocalizedStringKey("Reset Passcode"))
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 26, weight: .regular, design: .default))
                }
                .frame(width: 300, height: 55, alignment: .center)
            }
            .opacity(self.showResetButton ? 1 : 0)
        }
        .onAppear {
            if self.askBiometrix {
                tryBiometricAuthentication()
            }
        }
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 25, weight: .thin, design: .default))
                    .foregroundColor(textColor)
                Spacer()
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
      
           .accentColor(.clear)
           .foregroundColor(.clear)
           .keyboardType(.numberPad)
           .disabled(isDisabled)
      
             .introspectTextField { textField in
                 textField.tintColor = .clear
                 textField.textColor = .clear
                 textField.keyboardType = .numberPad
                 textField.becomeFirstResponder()
                 textField.isEnabled = !self.isDisabled
         }
    }
    
    private var showPinStack: some View {
        HStack {
            Spacer()
            if !pin.isEmpty {
                showPinButton
            }
        }
        .frame(height: 30)
        .padding([.trailing])
    }
    
    private var showPinButton: some View {
        Button(action: {
            self.showPin.toggle()
        }, label: {
            self.showPin ?
                Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
                Image(systemName: "eye.fill").foregroundColor(.primary)
        })
    }
    
    private func submitPin() {
        guard !pin.isEmpty else {
            showPin = false
            return
        }
        
        if pin.count == maxDigits {
            isDisabled = true
            if self.isNewPasscode {
                let keychain = Keychain(service: "zh.ayazbayeva.FInEx")
                    .synchronizable(true)
                    .accessibility(.afterFirstUnlock)
                keychain[KeychainAccessKeys.Passcode] = pin
                presentationMode.wrappedValue.dismiss()
            } else {
                let keychain = Keychain(service: "zh.ayazbayeva.FInEx")
                let savedPasscode = keychain[KeychainAccessKeys.Passcode]
                if pin == savedPasscode {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    self.textColor = .red
                    isDisabled = false
                    self.showResetButton = true
                }
                
            }
            
//            handler(pin) { isSuccess in
//                if isSuccess {
//                    print("pin matched, go to next page, no action to perfrom here")
//                } else {
//                    pin = ""
//                    isDisabled = false
//                    print("this has to called after showing toast why is the failure")
//                }
//            }
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func resetPasscode() {
        let context = LAContext()
        let reason = "Authenticate to unlock FinEx app."
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
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "circle"
        }
        
        if self.showPin {
            return self.pin.digits[index].numberString + ".circle"
        }
        
        return "circle.fill"
    }
    
    private func tryBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to unlock FInEx app."
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



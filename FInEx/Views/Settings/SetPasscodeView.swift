//
//  SetPasscodeView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-17.
//

import SwiftUI

struct SetPasscodeView: View {
    @State var passcode: String
    var body: some View {
        VStack {
            Text("Enter a new passcode")
                
            TextField("....", text: self.$passcode)
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                    textField.textAlignment = NSTextAlignment.center
                }
                .keyboardType(.numberPad)
                .mask(Rectangle().fill(Color.gray).opacity(0.9))
        }
        .font(Font.system(size: 30, weight: .light, design: .default))
        .foregroundColor(CustomColors.TextDarkGray)
    }
}

struct SetPasscodeView_Previews: PreviewProvider {
    static var previews: some View {
        SetPasscodeView(passcode: "")
    }
}

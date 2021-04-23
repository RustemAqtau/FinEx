//
//  PasscodeView.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-17.
//

import SwiftUI

struct PasscodeView: View {
    @State var enablePasscode: Bool = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    Text("Protect your data with a passcode. This way only you can enter and access your information.")
                        
                    Divider()
                        .frame(width: geo.size.width * 0.90)
                    HStack(alignment: .center) {
                        Toggle(isOn: self.$enablePasscode, label: {
                            Text("Enable Passcode")
                        })
                    }
                    .frame(width: geo.size.width * 0.90, alignment: .leading)
                }
                .font(Font.system(size: 20, weight: .light, design: .default))
                .foregroundColor(CustomColors.TextDarkGray)
                .padding()
                
            }
            
        }
        
        
        
    }
}

struct PasscodeView_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeView()
    }
}

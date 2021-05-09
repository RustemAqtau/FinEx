//
//  SettingsCustomBackButton.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-05-08.
//

import SwiftUI

struct SettingsCustomBackButton: View {
    @Binding var hideTabBar: Bool
    
    var body: some View {
        Button(action: {
            hideTabBar = false
        }) {
            Image(systemName: "chevron.backward")
        }
    }
}



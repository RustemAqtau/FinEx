//
//  UserSettingsInfo.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-09.
//

import Foundation

struct UserSettingsInfo {
    var settingsId: Int
    var isSignedWithAppleId: Bool
    var isSetPassCode: Bool
    
    init(settingsId: Int, isSignedWithAppleId: Bool, isSetPassCode: Bool) {
        self.settingsId = settingsId
        self.isSignedWithAppleId = isSignedWithAppleId
        self.isSetPassCode = isSetPassCode
    }
}

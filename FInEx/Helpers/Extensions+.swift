//
//  Extensions+.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-15.
//

import SwiftUI

struct UserSettingsVMKey: EnvironmentKey {
    static var defaultValue: UserSettingsManager = UserSettingsManager()
}

extension EnvironmentValues {
    var userSettingsVM: UserSettingsManager {
        get { self[UserSettingsVMKey.self] }
        set { self[UserSettingsVMKey.self] = newValue }
    }
}

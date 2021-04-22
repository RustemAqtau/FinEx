//
//  Extensions+.swift
//  FInEx
//
//  Created by Zhansaya Ayazbayeva on 2021-04-15.
//

import SwiftUI

extension EnvironmentValues {
    var userSettingsVM: UserSettingsManager {
        get { self[UserSettingsVMKey.self] }
        set { self[UserSettingsVMKey.self] = newValue }
    }
}

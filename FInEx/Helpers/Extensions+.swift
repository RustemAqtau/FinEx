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

extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

//
//  GiniSwitchSdkStorage.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 23.05.17.
//
//

import UIKit

// TODO: There should be a better way to access the Switch SDK object, but for now,
// this will have to do
class GiniSwitchSdkStorage {

    static var activeSwitchSdk:GiniSwitchSdk! = nil
    
}

/// Convenience method for getting the currently active appearance object
func currentSwitchAppearance() -> GiniSwitchAppearance {
    return GiniSwitchSdkStorage.activeSwitchSdk?.appearance ?? GiniSwitchAppearance()
}

func currentSwitchSdk() -> GiniSwitchSdk {
    return GiniSwitchSdkStorage.activeSwitchSdk
}

func Logger() -> GiniSwitchLogger {
    return currentSwitchSdk().configuration.logging
}

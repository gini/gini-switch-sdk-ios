//
//  TariffSdkStorage.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 23.05.17.
//
//

import UIKit

// TODO: There should be a better way to access the Tariff SDK object, but for now, 
// this will have to do
class TariffSdkStorage {

    static var activeTariffSdk:TariffSdk? = nil
    
}

/// Convenience method for getting the currently active appearance object
func currentTariffAppearance() -> TariffAppearance {
    return TariffSdkStorage.activeTariffSdk?.appearance ?? TariffAppearance()   // TODO: is returning an empty object ok?
}

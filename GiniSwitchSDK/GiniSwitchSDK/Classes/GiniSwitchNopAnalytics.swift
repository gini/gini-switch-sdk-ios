//
//  GiniSwitchNopAnalytics.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

import UIKit

class GiniSwitchNopAnalytics: GiniSwitchAnalytics {
    
    func sendAnalyticsEvent(type:AnalyticsEventType, eventName:String) {
        
    }
    
    func sendAnalyticsEvent(type:AnalyticsEventType, eventName:String, payload:[String: AnyObject]?) {
        
    }

}

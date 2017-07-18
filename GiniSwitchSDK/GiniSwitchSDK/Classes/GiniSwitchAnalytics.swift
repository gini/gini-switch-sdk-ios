//
//  GiniSwitchAnalytics.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

enum AnalyticsEventType {
    case button
    case screen
    case popup
    case event
}

protocol GiniSwitchAnalytics {

    func sendAnalyticsEvent(type:AnalyticsEventType, eventName:String)
    func sendAnalyticsEvent(type:AnalyticsEventType, eventName:String, payload:[String: AnyObject]?)
    
}

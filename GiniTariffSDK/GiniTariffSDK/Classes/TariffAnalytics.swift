//
//  TariffAnalytics.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

enum AnalyticsEventType {
    case button
    case screen
    case popup
    case event
}

protocol TariffAnalytics {

    func sendAnalyticsEvent(type:AnalyticsEventType, eventName:String)
    func sendAnalyticsEvent(type:AnalyticsEventType, eventName:String, payload:[String: AnyObject]?)
    
}

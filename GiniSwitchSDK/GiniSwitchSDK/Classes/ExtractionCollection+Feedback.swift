//
//  ExtractionCollection+Feedback.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.08.17.
//
//

import Foundation

extension ExtractionCollection {
    
    func feedbackJson() -> Data {
        let jsonDict = extractions.reduce(JSONDictionary()) { (jsonDict:JSONDictionary, extraction) -> JSONDictionary in
            var newDict = jsonDict
            newDict[extraction.name] = extraction.jsonDict as AnyObject
            return newDict
        }
        return (try? JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)) ?? Data()
    }
    
}

extension Extraction {
    
    var jsonDict:JSONDictionary {
        return value.jsonDict
    }
}

extension ExtractionValue {
    
    var jsonDict:JSONDictionary {
        var valueDict = [ExtractionValue.valueKey: value]
        if let unit = unit {
            valueDict[ExtractionValue.unitKey] = unit as AnyObject
        }
        return valueDict
    }
}

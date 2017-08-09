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
        let jsonDict = extractions.reduce([]) { (jsonArray:[JSONDictionary], extraction) -> [JSONDictionary] in
            var json = jsonArray
            json.append(extraction.jsonDict)
            return json
        }
        return (try? JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)) ?? Data()
    }
    
    func collectionWithDifferences(otherCollection:ExtractionCollection) -> ExtractionCollection {
        let differences = otherCollection.extractions.filter { (extraction) -> Bool in
            return !self.extractions.contains(extraction)
        }
        return ExtractionCollection(collection: differences)
    }
    
    static func feedbackJsonFor(feedback:ExtractionCollection, original:ExtractionCollection) -> Data {
        let difference = original.collectionWithDifferences(otherCollection: feedback)
        return difference.feedbackJson()
    }
}

extension Extraction {
    
    var jsonDict:JSONDictionary {
        return [name: value.jsonDict as AnyObject]
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

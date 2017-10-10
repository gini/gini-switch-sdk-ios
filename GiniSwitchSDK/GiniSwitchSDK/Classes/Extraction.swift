//
//  Extraction.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

public class  Extraction {

    public let name:String
    public var value:ExtractionValue = ExtractionValue(value: "", unit: nil)
    public var alternatives:[ExtractionValue] = []
    
    public var valueString:String {
        return value.valueString
    }
    
    public convenience init() {
        self.init(name: "", value: "")
    }
    
    public init(name:String, value:Any) {
        self.name = name
        self.value = ExtractionValue(value: value, unit: nil)
        alternatives = []
    }
    
    init(name:String, dict: JSONDictionary) {
        self.name = name
        parseValue(dict)
        parseAlternatives(dict)
    }
    
}

// Parsing
extension Extraction {
    
    func parseValue(_ dict:JSONDictionary) {
        if let stringValue = dict["value"] as? String {
            value = ExtractionValue(value: stringValue, unit: nil)
        }
        else if let objValue = ExtractionValue(dictionary: dict) {
            value = objValue
        }
    }
    
    func parseAlternatives(_ dict:JSONDictionary) {
        let alternativesDict = dict["alternatives"] as? [JSONDictionary] ?? []
        alternatives = alternativesDict.flatMap { (altDict) -> ExtractionValue in
            return ExtractionValue(dictionary: altDict) ?? ExtractionValue(value: "" as AnyObject, unit: nil) // TODO: maybe filter those?
        }
    }
}

extension Extraction:Equatable {
    
    public static func ==(lhs: Extraction, rhs: Extraction) -> Bool {
        var equalAlternatives = true
        for (val1, val2) in zip(lhs.alternatives, rhs.alternatives) {
            equalAlternatives = equalAlternatives && val1 == val2
        }
        return lhs.name == rhs.name &&
            lhs.value == rhs.value &&
            equalAlternatives &&
            lhs.alternatives.count == rhs.alternatives.count
    }
    
}

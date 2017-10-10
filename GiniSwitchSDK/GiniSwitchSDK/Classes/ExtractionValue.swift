//
//  ExtractionValue.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.06.17.
//
//

public struct ExtractionValue {
    
    public let value:Any
    public let unit:String?
    
    static let valueKey = "value"
    static let unitKey = "unit"
    
    public var valueString:String {
        return "\(value)"
    }
    
    public init(value val:Any, unit:String?) {
        self.value = val
        self.unit = unit
    }
    
    init?(dictionary:JSONDictionary) {
        // In any case, there needs to be a "value" key
        guard let dictValue = dictionary[ExtractionValue.valueKey],
            let val = dictValue else {
                return nil
        }
        // Also, the value might be a value/unit pair
        if let json = dictionary[ExtractionValue.valueKey] as? JSONDictionary,
            let jsonValue = json[ExtractionValue.valueKey],
            let value = jsonValue {
            self.init(value:value, unit: dictionary[ExtractionValue.unitKey] as? String)
        }
        // Lastly, the value might be just a top level object
        else {
            self.init(value:val, unit: dictionary[ExtractionValue.unitKey] as? String)
        }
    }
    
    public static func ==(lhs: ExtractionValue, rhs: ExtractionValue) -> Bool {
        return lhs.unit == rhs.unit && lhs.valueString == rhs.valueString
    }

}

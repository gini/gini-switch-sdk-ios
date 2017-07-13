//
//  ExtractionValue.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.06.17.
//
//

struct ExtractionValue {
    
    let value:AnyObject
    let unit:String?
    
    var valueString:String {
        return "\(value)"
    }
    
    init(value val:AnyObject, unit:String?) {
        self.value = val
        self.unit = unit
    }
    
    init?(dictionary:JSONDictionary) {
        guard let val = dictionary["value"] as AnyObject? else {
                return nil
        }
        self.init(value:val, unit: dictionary["unit"] as? String)
    }
    
    static func ==(lhs: ExtractionValue, rhs: ExtractionValue) -> Bool {
        return lhs.unit == rhs.unit && lhs.valueString == rhs.valueString
    }

}

//
//  Extraction.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

public class  Extraction<T: ExtractionValue> : Codable {

    public var name:String = ""
    public var value:T? = nil
    public var alternatives:[T] = []
    
    public var valueString:String {
        return value?.valueString ?? ""
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

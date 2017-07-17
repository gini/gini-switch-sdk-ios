//
//  ExtractionCollection.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

import UIKit

public class ExtractionCollection:BaseApiResponse {

    let extractions:[Extraction]
    
    init() {
        extractions = []
        super.init(href: "")
    }
    
    init(collection:[Extraction]) {
        extractions = collection
        super.init(href: "")
    }
    
    init?(dictionary:JSONDictionary) {
        extractions = dictionary.keys.map { (name) -> Extraction in
            let extractionDict = dictionary[name] as? JSONDictionary ?? [:]
            return Extraction(name: name, dict: extractionDict)
            }.filter{ !$0.value.valueString.isEmpty }
        super.init(dict: dictionary)
    }
    
}

extension ExtractionCollection:Equatable {
    
    public static func ==(lhs: ExtractionCollection, rhs: ExtractionCollection) -> Bool {
        return lhs.extractions == rhs.extractions
    }
    
}

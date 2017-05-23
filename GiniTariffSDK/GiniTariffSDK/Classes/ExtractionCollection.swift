//
//  ExtractionCollection.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 22.05.17.
//
//

import UIKit

struct ExtractionCollection {

    var extractions:[Extraction] = []
    
    init() {
        
    }
    
    init?(dictionary:[String:String]?) {
        guard let dict = dictionary else {
            return nil
        }

        for (name, value) in dict {
            extractions.append(Extraction(name:name, value:value))
        }
    }
    
}

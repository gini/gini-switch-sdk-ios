//
//  PageCollection.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 15.05.17.
//
//

import UIKit

// TODO: choose a fitting swift collection type and make PageCollection conform to it
class PageCollection {
    
    var pages:[ScanPage] = []
    
    init() {
        
    }
    
    init(pages:[ScanPage]) {
        self.pages = pages
    }

    var count:Int {
        return pages.count
    }
    
    var last:ScanPage? {
        return pages.last
    }
    
    func add(element:ScanPage) {
        self.pages.append(element)
    }
    
    func remove(at index:Int) {
        guard count > 0 else {
            return
        }
        self.pages.remove(at: index)
    }

}

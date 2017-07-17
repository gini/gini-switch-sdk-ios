//
//  PageCollection.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.05.17.
//
//

import UIKit

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
    
    func remove(_ element:ScanPage?) {
        guard let page = element,
        let index = pages.index(of: page) else { return }
        pages.remove(at: index)
    }
    
    func page(for url:String) -> ScanPage? {
        let pageMatches = pages.filter { (page) -> Bool in
            return page.id == url
        }
        return pageMatches.first    // there should be only one
    }

}

extension PageCollection: Equatable {
    
    public static func ==(lhs: PageCollection, rhs: PageCollection) -> Bool {
        return lhs.pages == rhs.pages
    }
}

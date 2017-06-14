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
    
    func remove(_ element:ScanPage?) {
        guard let page = element,
        let index = pages.index(of: page) else { return }
        // TODO: maybe there is a better way than searching for the index?
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

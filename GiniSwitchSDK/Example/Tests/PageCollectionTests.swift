//
//  PageCollectionTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class PageCollectionTests: XCTestCase {
    
    var pages:PageCollection! = nil
    
    func testCreateEmptyPageCollection() {
        pages = PageCollection()
        XCTAssertNotNil(pages, "Should be able to create empty pages collection")
    }
    
    func testCreateCollectionWithListsOfPages() {
        pages = PageCollection(pages:[ScanPage(), ScanPage(), ScanPage()])
        XCTAssertNotNil(pages)
    }
   
    func testAccesingPagesArray() {
        let testPages = [ScanPage()]
        pages = PageCollection(pages:testPages)
        XCTAssertEqual(pages.pages, testPages, "The pages array should be accessible and equal to the one passed via the init method")
    }
    
    func testPagesCount() {
        let testPages = [ScanPage(), ScanPage(), ScanPage(), ScanPage()]
        pages = PageCollection(pages:testPages)
        XCTAssertEqual(pages.count, testPages.count, "The number of pages should be returned from the count method")
    }
    
    func testPageCountEmptyCollection() {
        pages = PageCollection()
        XCTAssertEqual(pages.count, 0, "An empty collection should have zero as count")
    }
    
    func testAddingPage() {
        let numPages = 7
        pages = collectionWithEmptyElements(num: numPages)
        let addedPage = ScanPage()
        pages.add(element: addedPage)
        XCTAssertEqual(pages.count, numPages + 1, "Adding an element should result in the count growing")
        XCTAssertEqual(pages.last!, addedPage, "The last page should be the one just added")
    }
    
    func testRemovingPage() {
        let numPages = 3
        pages = collectionWithEmptyElements(num: numPages)
        pages.remove(at: 0)
        XCTAssertEqual(pages.count, numPages - 1, "Removing an element should result in the count decreasing")
    }
    
    func testRemovingFromEmptyCollection() {
        pages = PageCollection()
        pages.remove(at: 0)
        XCTAssertEqual(pages.count, 0, "Removing an element from an empty collection should silently fail")
    }
    
    func testRemovingByReference() {
        let elements = [ScanPage(imageData: Data(), id:"1"),
                        ScanPage(imageData: Data(), id:"2"),
                        ScanPage(imageData: Data(), id:"3")]
        pages = PageCollection(pages:elements)
        let numPages = pages.count
        let secondElement = pages.pages[1]
        pages.remove(secondElement)
        XCTAssertEqual(pages.count, numPages - 1, "Removing an element should result in the count decreasing")
        XCTAssertFalse(pages.pages.contains(secondElement), "The pages array shouls no longer contain the removed element")
    }
    
}

extension PageCollectionTests {
    
    func collectionWithEmptyElements(num:Int) -> PageCollection {
        var elements:[ScanPage] = []
        for _ in 1...num {
            elements.append(ScanPage())
        }
        return PageCollection(pages:elements)
    }
}

//
//  PageCollectionTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 15.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class PageCollectionTests: XCTestCase {
    
    var pages:PageCollection! = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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

//
//  PageCollectionViewCellTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 11.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class PageCollectionViewCellTests: XCTestCase {
    
    let storyboard = tariffStoryboard()
    var pageCell:PageCollectionViewCell! = nil
    
    override func setUp() {
        super.setUp()
        pageCell = initializeCellFromStoryboard()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCanCreatePageCollectionCell() {
        XCTAssertNotNil(pageCell, "Should be able to create a PageCollectionViewCell")
    }
    
    func testHasPagePreview() {
        XCTAssertNotNil(pageCell.pagePreview, "PageCollectionViewCell should have an image view to preview pages")
    }
    
    func testHasPageStatus() {
        XCTAssertNotNil(pageCell.pageStatusView, "PageCollectionViewCell should have an image view to show status")
    }
    
    func testHasPageStatusUnderline() {
        XCTAssertNotNil(pageCell.pageStatusUnderlineView, "PageCollectionViewCell should have an inderline, showing page status")
    }
    
    func testCanShowPreview() {
        let dummyImage = UIImage()
        pageCell.image = dummyImage
        XCTAssertEqual(pageCell.pagePreview.image, dummyImage, "Setting the image proprty should also set the image on the preview view")
    }
    
    func testCanSetPageStatusToFailed() {
        let state:PageStatus = .failed
        pageCell.status = state
        XCTAssertEqual(pageCell.status, state, "Should be able to store the page status in a page cell")
    }
    
    func testCanSetPageStatusToOk() {
        let state:PageStatus = .ok
        pageCell.status = state
        XCTAssertEqual(pageCell.status, state, "Should be able to store the page status in a page cell")
    }
    
}

extension PageCollectionViewCellTests {
    
    func initializeCellFromStoryboard() -> PageCollectionViewCell {
        // since the cell is embedded into a view controller within the storyboard, to get an object
        // of it, the whole view controller needs to be initialized from the storyboard.
        // Then, using the collection view data source methods, a cell can be created and returned
        //return PageCollectionViewCell()
        let pagesController = storyboard?.instantiateViewController(withIdentifier: "PagesCollectionViewController") as! PagesCollectionViewController
        _ = pagesController.view
        let indexPath = IndexPath(item: 0, section: 0)
        return pagesController.collectionView(pagesController.pagesCollection, cellForItemAt: indexPath) as! PageCollectionViewCell
    }
}

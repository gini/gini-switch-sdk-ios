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
    
    let storyboard = UIStoryboard.tariffStoryboard()
    var pageCell:PageCollectionViewCell! = nil
    
    override func setUp() {
        super.setUp()
        pageCell = initializeCellFromStoryboard()
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
        let state:ScanPageStatus = .failed
        pageCell.status = state
        XCTAssertEqual(pageCell.status, state, "Should be able to store the page status in a page cell")
    }
    
    func testCanSetPageStatusToOk() {
        let state:ScanPageStatus = .uploaded
        pageCell.status = state
        XCTAssertEqual(pageCell.status, state, "Should be able to store the page status in a page cell")
    }
    
    func testInitWithScanPage() {
        let page = ScanPage(imageData: testImageData(), id: "test", status: .failed)
        pageCell.page = page
        // only check the image sizes - it's not as deterministic as comparing images but simpler
        XCTAssertEqual(pageCell.image?.size, UIImage(data: page.imageData!)?.size, "The image from ScanPage should be displayed on the cell page")
        XCTAssertEqual(pageCell.status, page.status, "The status from ScanPage should be displayed on the cell page")
    }
    
    func testDataSourceReturningPopulatedCells() {
        let page = ScanPage()
        pageCell = initializeCellFromStoryboard(pageCollection:PageCollection(pages:[page]))
        XCTAssertEqual(pageCell.page, page, "The cell should be initialized with the right page from the collection from the data source methods")
    }
    
    func testAddPhotoCell() {
        // it would be a cell from the second section in the collection view
        pageCell = initializeCellFromStoryboard(pageCollection: nil, indexPath: IndexPath(row:0, section:1))
        XCTAssertEqual(pageCell.image, nil, "The add picture button should have an image")
        XCTAssertEqual(pageCell.pagePreview.backgroundColor, UIColor.gray, "The add picture button should have a gray background")
        XCTAssertEqual(pageCell.pageStatusUnderlineView.backgroundColor, UIColor.clear, "The add picture button shouldn't have an underline")
        // TODO: maybe check the image view also?
    }
    
}

extension PageCollectionViewCellTests {
    
    func initializeCellFromStoryboard(pageCollection:PageCollection? = nil, indexPath:IndexPath = IndexPath(item: 0, section: 0)) -> PageCollectionViewCell {
        // since the cell is embedded into a view controller within the storyboard, to get an object
        // of it, the whole view controller needs to be initialized from the storyboard.
        // Then, using the collection view data source methods, a cell can be created and returned
        let pagesController = storyboard?.instantiateViewController(withIdentifier: "PagesCollectionViewController") as! PagesCollectionViewController
        _ = pagesController.view
        if let collection = pageCollection {
            pagesController.pages = collection
        }
        else {
            pagesController.pages = PageCollection(pages:[ScanPage()])
        }
        return pagesController.collectionView(pagesController.pagesCollection!, cellForItemAt: indexPath) as! PageCollectionViewCell
    }
}

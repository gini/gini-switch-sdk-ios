//
//  PagesCollectionViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 11.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class PagesCollectionViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard.switchStoryboard()
    var pagesController:PagesCollectionViewController! = nil
    
    var didRequestOptions = false
    var didRequestAddPage = false
    var selectedPage:ScanPage? = nil
    
    override func setUp() {
        super.setUp()
        pagesController = storyboard?.instantiateViewController(withIdentifier: "PagesCollectionViewController") as! PagesCollectionViewController
        _ = pagesController.view
        didRequestOptions = false
        didRequestAddPage = false
        selectedPage = nil
    }
    
    func testPagesCollectionViewControllerFromStoryboard() {
        XCTAssertNotNil(pagesController, "Should be able to initialize PagesCollectionViewController from the storyboard")
    }
    
    func testPagesCollectionViewControllerHasOptionsButton() {
        XCTAssertNotNil(pagesController.optionsButton, "PagesCollectionViewController should have a options button")
    }
    
    func testPagesCollectionViewControllerHasPagesCollection() {
        XCTAssertNotNil(pagesController.pagesCollection, "PagesCollectionViewController should have a pages collection view")
    }
    
    func testPagesCollectionViewIsTransparent() {
        XCTAssertEqual(pagesController.pagesCollection?.backgroundColor, UIColor.clear, "The Pages collection view should have a transparent background")
    }
    
    func testIsCollectionViewDelegate() {
        let delegate = pagesController as UICollectionViewDelegate
        XCTAssertNotNil(delegate, "PagesCollectionViewController needs to be a UICollectionViewDelegate in order to handle cell selection events")
    }
    
    func testIsCollectionViewDataSource() {
        let delegate = pagesController as UICollectionViewDataSource
        XCTAssertNotNil(delegate, "PagesCollectionViewController needs to be a UICollectionViewDataSource")
    }
    
    func testIsDelegateSet() {
        XCTAssertTrue(pagesController.pagesCollection?.delegate === pagesController, "PagesCollectionViewController should be its collection view's delegate")
    }
    
    func testIsDataSourceSet() {
        XCTAssertTrue(pagesController.pagesCollection?.dataSource === pagesController, "PagesCollectionViewController should be its collection view's data source")
    }
    
    func testHasDelegate() {
        pagesController.delegate = self
        XCTAssertTrue(pagesController.delegate === self, "PagesCollectionViewController should have a delegate")
    }
    
    func testHasPageCollection() {
        let page = ScanPage()
        let collection = PageCollection(pages: [page])
        pagesController.pages = collection
        XCTAssertEqual(pagesController.pages, collection, "PagesCollectionViewController should have a page collection property")
    }
    
    func testHasRightNumberOfRows() {
        let page1 = ScanPage()
        let page2 = ScanPage()
        let collection = PageCollection(pages: [page1, page2])
        pagesController.pages = collection
        XCTAssertEqual(pagesController.collectionView(pagesController.pagesCollection!, numberOfItemsInSection: 0), collection.count, "In the first section, the number of rows should be the same as the number of pages in the pages colleciton")
    }
    
    func testHasOneRowForSecondSection() {
        XCTAssertEqual(pagesController.collectionView(pagesController.pagesCollection!, numberOfItemsInSection: 1), 1, "In the second section, the number of rows should be 1 - the add page cell")
    }
    
    func testAlwaysHasOneCellInSectionTwo() {
        let page1 = ScanPage()
        let page2 = ScanPage()
        let collection = PageCollection(pages: [page1, page2])
        pagesController.pages = collection
        XCTAssertEqual(pagesController.collectionView(pagesController.pagesCollection!, numberOfItemsInSection: 1), 1, "In the second section, the number of rows should be 1, despite the added pages")
    }
    
    func testHavingTwoSections() {
        let sectionsNum = pagesController.numberOfSections(in: pagesController.pagesCollection!)
        XCTAssertEqual(sectionsNum, 2, "PagesCollectionViewController should have two sections - one for pages and one for the add page cell")
    }
    
    func testStartingWithZeroPages() {
        let rowsNum = pagesController.collectionView(pagesController.pagesCollection!, numberOfItemsInSection: 0)
        XCTAssertEqual(rowsNum, 0, "By default PagesCollectionViewController should start with zero pages")
    }
    
    func testTappingOnOptions() {
        pagesController.delegate = self
        pagesController.onOptionsTapped()
        XCTAssertTrue(didRequestOptions, "When the options button is tapped, the delegate needs to be notified")
    }
    
    func testSelectingPage() {
        let page1 = ScanPage()
        let collection = PageCollection(pages: [page1])
        pagesController.pages = collection
        pagesController.delegate = self
        pagesController.collectionView(pagesController.pagesCollection!, didSelectItemAt: IndexPath(row:0, section:0))
        XCTAssertEqual(selectedPage, page1, "When a page from the collection view is selected, the delegate needs to be notified")
    }
    
    func testSelectingAddPageNotInvokingDidSelectItem() {
        let page1 = ScanPage()
        let collection = PageCollection(pages: [page1])
        pagesController.pages = collection
        pagesController.delegate = self
        pagesController.collectionView(pagesController.pagesCollection!, didSelectItemAt: IndexPath(row:0, section:1))
        XCTAssertNil(selectedPage, "When the add page cell from the collection view is selected, the delegate shouldn't be notified about a selected page")
    }
    
    func testSelectingAddPageInvokingAddPageMethod() {
        let page1 = ScanPage()
        let collection = PageCollection(pages: [page1])
        pagesController.pages = collection
        pagesController.delegate = self
        pagesController.collectionView(pagesController.pagesCollection!, didSelectItemAt: IndexPath(row:0, section:1))
    }
    
    func testSettingPageNumbers() {
        let page1 = ScanPage()
        let collection = PageCollection(pages: [page1])
        pagesController.pages = collection
        let cell = pagesController.collectionView(pagesController.pagesCollection!, cellForItemAt: IndexPath(row:0, section:0)) as? PageCollectionViewCell
        XCTAssertEqual(cell?.pageNumber, 1, "PagesCollectionViewController should set page numbers on cells")
    }
    
    func testSectionOnePageNumber() {
        let page1 = ScanPage()
        let collection = PageCollection(pages: [page1])
        pagesController.pages = collection
        let cell = pagesController.collectionView(pagesController.pagesCollection!, cellForItemAt: IndexPath(row:0, section:1)) as? PageCollectionViewCell
        XCTAssertEqual(cell?.pageNumber, 2, "PagesCollectionViewController should set page numbers on cells")
    }
}

extension PagesCollectionViewControllerTests: PagesCollectionViewControllerDelegate {
    
    func pageCollectionControllerDidRequestOptions(_ pageController:PagesCollectionViewController) {
        didRequestOptions = true
    }
    
    func pageCollectionController(_ pageController:PagesCollectionViewController, didSelectPage:ScanPage) {
        selectedPage = didSelectPage
    }
    
    func pageCollectionControllerDidRequestAddPage(_ pageController:PagesCollectionViewController) {
        didRequestAddPage = true
    }
    
}

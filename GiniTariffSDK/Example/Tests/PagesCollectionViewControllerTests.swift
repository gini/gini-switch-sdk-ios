//
//  PagesCollectionViewControllerTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 11.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class PagesCollectionViewControllerTests: XCTestCase {
    
    let storyboard = tariffStoryboard()
    var pagesController:PagesCollectionViewController! = nil
    
    override func setUp() {
        super.setUp()
        pagesController = storyboard?.instantiateViewController(withIdentifier: "PagesCollectionViewController") as! PagesCollectionViewController
        _ = pagesController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
        XCTAssertEqual(pagesController.pagesCollection.backgroundColor, UIColor.clear, "The Pages collection view should have a transparent background")
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
        XCTAssertTrue(pagesController.pagesCollection.delegate === pagesController, "PagesCollectionViewController should be its collection view's delegate")
    }
    
    func testIsDataSourceSet() {
        XCTAssertTrue(pagesController.pagesCollection.dataSource === pagesController, "PagesCollectionViewController should be its collection view's data source")
    }
    
}

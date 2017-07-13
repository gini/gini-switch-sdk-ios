//
//  ExtractionsViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ExtractionsViewControllerTests: XCTestCase {
    
    var extractionsController:ExtractionsViewController! = nil
    let storyboard = tariffStoryboard()
    
    override func setUp() {
        super.setUp()
        extractionsController = storyboard?.instantiateViewController(withIdentifier: "ExtractionsViewController") as! ExtractionsViewController
        _ = extractionsController.view
    }
    
    func testHasHintTest() {
        XCTAssertNotNil(extractionsController.titleHintLabel, "The hint test label should be available for customizations")
    }
    
    func testHasTableView() {
        XCTAssertNotNil(extractionsController.extractionsTable, "ExtractionsViewController should have a table of extractions")
    }
    
    func testHasSwitchButton() {
        XCTAssertNotNil(extractionsController.switchButton, "ExtractionsViewController should have a switch button")
    }
    
    func testIsTableViewDelegate() {
        XCTAssertTrue(extractionsController.extractionsTable.delegate === extractionsController, "ExtractionsViewController should br the extraction table's delegate")
    }
    
    func testIsTableViewDataSource() {
        XCTAssertTrue(extractionsController.extractionsTable.dataSource === extractionsController, "ExtractionsViewController should br the extraction table's data source")
    }
    
    func testHasNavigationBar() {
        // embed in a navigation controller
        extractionsController = storyboard?.instantiateViewController(withIdentifier: "ExtractionsViewController") as! ExtractionsViewController
        _ = UINavigationController(rootViewController: extractionsController)
        _ = extractionsController.view
        XCTAssertFalse(extractionsController.navigationController?.isNavigationBarHidden ?? true, "ExtractionsViewController should have a navigation bar allowing users to go back")
    }
    
    func testHasOneSection() {
        XCTAssertEqual(extractionsController.numberOfSections(in: extractionsController.extractionsTable), 1, "The table should only have one section")
    }
    
    func testHasRightNumberOfCells() {
        let collection = ExtractionCollection(collection:[Extraction(), Extraction(), Extraction(), Extraction()])
        extractionsController.extractionsCollection = collection
        XCTAssertEqual(extractionsController.tableView(extractionsController.extractionsTable, numberOfRowsInSection: 0), 4, "Four extractions should show up as four cells in the ExtractionsViewController")
    }
    
}

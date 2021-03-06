//
//  ExtractionsTableViewCellTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class ExtractionsTableViewCellTests: XCTestCase {
    
    var extractionCell:ExtractionsTableViewCell! = nil
    let storyboard = UIStoryboard.switchStoryboard()
    let testField = "zip"
    let testValue = "80333"
    
    override func setUp() {
        super.setUp()
        let extraction = Extraction(name: testField, value: testValue as AnyObject)
        let collection = ExtractionCollection(collection: [extraction])
        extractionCell = initializeCellFromStoryboard(extractionCollection: collection)
    }
    
    func testHasNameLabel() {
        XCTAssertNotNil(extractionCell.nameLabel, "ExtractionsTableViewCell should have a name label")
    }
    
    func testHasValueTextField() {
        XCTAssertNotNil(extractionCell.valueTextField, "ExtractionsTableViewCell should have a value text field")
    }
    
    func testSettingExtraction() {
        XCTAssertEqual(extractionCell.nameLabel.text, testField, "The cell should be initialized with the field name provided by the extraction collection")
        XCTAssertEqual(extractionCell.valueTextField.text, testValue, "The cell should be initialized with the field name provided by the extraction collection")
    }
    
}

extension ExtractionsTableViewCellTests {
    
    func initializeCellFromStoryboard(extractionCollection:ExtractionCollection? = nil, indexPath:IndexPath = IndexPath(item: 0, section: 0)) -> ExtractionsTableViewCell {
        // since the cell is embedded into a view controller within the storyboard, to get an object
        // of it, the whole view controller needs to be initialized from the storyboard.
        // Then, using the collection view data source methods, a cell can be created and returned
        let extractionsController = storyboard?.instantiateViewController(withIdentifier: "ExtractionsViewController") as! ExtractionsViewController
        _ = extractionsController.view
        if let collection = extractionCollection {
            extractionsController.extractionsCollection = collection
        }
        else {
            extractionsController.extractionsCollection = ExtractionCollection()
        }
        return extractionsController.tableView(extractionsController.extractionsTable, cellForRowAt: indexPath) as! ExtractionsTableViewCell
    }
}

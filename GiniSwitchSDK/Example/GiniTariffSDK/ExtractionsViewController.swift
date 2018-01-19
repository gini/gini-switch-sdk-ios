//
//  ExtractionsViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

import UIKit
import GiniSwitchSDK

protocol ExtractionsViewControllerDelegate:class {
    
    func extractionsControllerDidSwitch(_ controller:ExtractionsViewController)
    func extractionsControllerDidGoBack(_ controller:ExtractionsViewController)
    
}

class ExtractionsViewController: UIViewController {
    
    @IBOutlet var titleHintLabel:UILabel! = nil
    @IBOutlet var extractionsTable:UITableView! = nil
    @IBOutlet var backButton:UIButton! = nil
    @IBOutlet var switchButton:UIButton! = nil
    
    var extractions:[(name:String, value: String)] = []
    var extractionsCollection:ExtractionCollection? = nil {
        didSet {
            var allExtractions:[(name:String?, value: String?)] = []
            allExtractions.append((name: "Company name", value: extractionsCollection?.companyName?.value?.valueString))
            allExtractions.append((name: "Customer address", value: extractionsCollection?.customerAddress?.value?.valueString))
            allExtractions.append((name: "Energy meter number", value: extractionsCollection?.energyMeterNumber?.value?.valueString))
            allExtractions.append((name: "Comsumption", value: extractionsCollection?.consumption?.value?.valueString))
            allExtractions.append((name: "Consumption duration", value: extractionsCollection?.consumptionDuration?.value?.valueString))
            allExtractions.append((name: "Paid amount", value: extractionsCollection?.paidAmount?.value?.valueString))
            allExtractions.append((name: "Amount to pay", value: extractionsCollection?.amountToPay?.value?.valueString))
            allExtractions.append((name: "Billing amount", value: extractionsCollection?.billingAmount?.value?.valueString))
            allExtractions.append((name: "Document date", value: extractionsCollection?.documentDate?.value?.valueString))
            extractions = allExtractions.filter({ $0.name != nil && $0.value != nil}).map({ (element) -> (name:String, value: String) in
                return (name:element.name!, value:element.value!)
            })
        }
    }
    weak var delegate:ExtractionsViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        extractionsTable.dataSource = self
        extractionsTable.delegate = self
    }
    
    @IBAction func onSwitchTapped() {
        delegate?.extractionsControllerDidSwitch(self)
    }
    
    @IBAction func onBack() {
        delegate?.extractionsControllerDidGoBack(self)
    }

}

extension ExtractionsViewController: UITableViewDelegate {
    
}

extension ExtractionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extractions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExtractionsTableViewCell", for: indexPath) as! ExtractionsTableViewCell
        let extraction = extractions[indexPath.row]
        cell.nameLabel.text = extraction.name
        cell.valueTextField.text = extraction.value
        cell.onExtractionChange = { (newValue: String) -> Void in
            // Since the data is shown in a text field, all entries are strings. However, it is
            // important to NOT change the data type in the extraction collection
            // (otherwise the backend might reject the data)
            // TODO: apply the changes in the extraction collection
//            extraction?.value = ExtractionValue(value: Double(newValue) ?? newValue, unit: extraction?.value.unit)
        }
        
        return cell
    }
    
}



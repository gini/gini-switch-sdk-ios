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

final class ExtractionsViewController: UIViewController {
    
    @IBOutlet var titleHintLabel:UILabel! = nil
    @IBOutlet var extractionsTable:UITableView! = nil
    @IBOutlet var backButton:UIButton! = nil
    @IBOutlet var switchButton:UIButton! = nil
    
    var extractions:[(name:String, value: String, changeBlock: (String) -> Void)] = []
    var extractionsCollection:ExtractionCollection? = nil {
        didSet {
            var allExtractions:[(name:String?, value: String?, changeBlock: (String) -> Void)] = []
            allExtractions.append((name: "Company name", value: extractionsCollection?.companyName?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.companyName?.value = changedValue
            }))
            allExtractions.append((name: "Customer name", value: extractionsCollection?.customerAddress?.value?.name, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.customerAddress?.value?.name = changedValue
            }))
            allExtractions.append((name: "Customer street name", value: extractionsCollection?.customerAddress?.value?.street?.streetName, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.customerAddress?.value?.street?.streetName = changedValue
            }))
            allExtractions.append((name: "Customer street number", value: extractionsCollection?.customerAddress?.value?.street?.streetNumber, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.customerAddress?.value?.street?.streetNumber = changedValue
            }))
            allExtractions.append((name: "Customer city", value: extractionsCollection?.customerAddress?.value?.city, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.customerAddress?.value?.city = changedValue
            }))
            allExtractions.append((name: "Customer country", value: extractionsCollection?.customerAddress?.value?.country, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.customerAddress?.value?.country = changedValue
            }))
            allExtractions.append((name: "Customer postal code", value: extractionsCollection?.customerAddress?.value?.postalCode, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.customerAddress?.value?.postalCode = changedValue
            }))
            allExtractions.append((name: "Energy meter number", value: extractionsCollection?.energyMeterNumber?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.energyMeterNumber?.value = changedValue
            }))
            allExtractions.append((name: "Comsumption", value: extractionsCollection?.consumption?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                if let numberValue = Double(changedValue) {
                    self?.extractionsCollection?.consumption?.value?.value = numberValue
                }
            }))
            allExtractions.append((name: "Consumption duration", value: extractionsCollection?.consumptionDuration?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                if let numberValue = Double(changedValue) {
                    self?.extractionsCollection?.consumptionDuration?.value?.value = numberValue
                }
            }))
            allExtractions.append((name: "Paid amount", value: extractionsCollection?.paidAmount?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                if let numberValue = Double(changedValue) {
                    self?.extractionsCollection?.paidAmount?.value?.value = numberValue
                }
            }))
            allExtractions.append((name: "Amount to pay", value: extractionsCollection?.amountToPay?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                if let numberValue = Double(changedValue) {
                    self?.extractionsCollection?.amountToPay?.value?.value = numberValue
                }
            }))
            allExtractions.append((name: "Billing amount", value: extractionsCollection?.billingAmount?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                if let numberValue = Double(changedValue) {
                    self?.extractionsCollection?.billingAmount?.value?.value = numberValue
                }
            }))
            allExtractions.append((name: "Document date", value: extractionsCollection?.documentDate?.value?.valueString, changeBlock: { [weak self] (changedValue) in
                self?.extractionsCollection?.documentDate?.value = changedValue
            }))
            extractions = allExtractions.flatMap {
                if let name = $0.name, let value = $0.value {
                    return (name: name, value: value, changeBlock:$0.changeBlock)
                }
                return nil
            }
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
            extraction.changeBlock(newValue)
        }
        
        return cell
    }
    
}



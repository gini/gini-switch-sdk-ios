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
    
    var extractionsCollection:ExtractionCollection? = nil
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
        return extractionsCollection?.extractions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExtractionsTableViewCell", for: indexPath) as! ExtractionsTableViewCell
        let extraction = extractionsCollection?.extractions[indexPath.row]
        cell.nameLabel.text = extraction?.name ?? ""
        cell.valueTextField.text = extraction?.valueString ?? ""
        cell.onExtractionChange = { (newValue: String) -> Void in
            // Since the data is shown in a text field, all entries are strings. However, it is
            // important to NOT change the data type in the extraction collection
            // (otherwise the backend might reject the data)
            extraction?.value = ExtractionValue(value: Double(newValue) ?? newValue, unit: extraction?.value.unit)
        }
        
        return cell
    }
    
}



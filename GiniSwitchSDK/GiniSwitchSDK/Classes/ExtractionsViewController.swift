//
//  ExtractionsViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

import UIKit

class ExtractionsViewController: UIViewController {
    
    @IBOutlet var titleHintLabel:UILabel! = nil
    @IBOutlet var extractionsTable:UITableView! = nil
    @IBOutlet var switchButton:UIButton! = nil
    
    var extractionsCollection:ExtractionCollection? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        extractionsTable.dataSource = self
        extractionsTable.delegate = self
        titleHintLabel.text = currentSwitchAppearance().extractionsScreenTitleText
        switchButton.setTitle(currentSwitchAppearance().extractionsButtonText, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onSwitchTapped() {
        currentSwitchSdk().delegate?.switchSdkDidComplete(sdk: currentSwitchSdk())
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
        cell.nameLabel.textColor = currentSwitchAppearance().extractionTitleTextColor
        cell.valueTextField.textColor = currentSwitchAppearance().extractionsTextFieldTextColor
        cell.valueTextField.layer.borderColor = currentSwitchAppearance().extractionsTextFieldBorderColor?.cgColor
        cell.valueTextField.backgroundColor = currentSwitchAppearance().extractionsTextFieldBackgroundColor
        
        return cell
    }
    
}

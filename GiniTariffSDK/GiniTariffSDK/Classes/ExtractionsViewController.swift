//
//  ExtractionsViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 22.05.17.
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
        titleHintLabel.text = currentTariffAppearance().extractionsScreenTitleText
        switchButton.setTitle(currentTariffAppearance().extractionsButtonText, for: .normal)
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
        TariffSdkStorage.activeTariffSdk?.delegate?.tariffSdkDidComplete(sdk: TariffSdkStorage.activeTariffSdk!)
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
        cell.nameLabel.textColor = currentTariffAppearance().extractionTitleTextColor
        cell.valueTextField.textColor = currentTariffAppearance().extractionsTextFieldTextColor
        cell.valueTextField.layer.borderColor = currentTariffAppearance().extractionsTextFieldBorderColor?.cgColor
        cell.valueTextField.backgroundColor = currentTariffAppearance().extractionsTextFieldBackgroundColor
        
        return cell
    }
    
}

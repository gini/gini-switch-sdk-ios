//
//  ExtractionsTableViewCell.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

import UIKit

final class ExtractionsTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel:UILabel! = nil
    @IBOutlet var valueTextField:UITextField! = nil {
        didSet {
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: valueTextField, queue: OperationQueue.main) { [weak self] (notification) in
                self?.onExtractionChange?(self?.valueTextField.text ?? "")
            }
        }
    }
    
    var onExtractionChange:((String) -> Void)? = nil
    
    @IBAction func onTextChange() {
        onExtractionChange?(valueTextField.text ?? "")
    }

}

extension ExtractionsTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

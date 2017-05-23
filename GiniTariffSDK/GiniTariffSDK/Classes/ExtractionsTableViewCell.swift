//
//  ExtractionsTableViewCell.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 22.05.17.
//
//

import UIKit

class ExtractionsTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel:UILabel! = nil
    @IBOutlet var valueTextField:UITextField! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

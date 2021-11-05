//
//  ListTableCell.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 04.11.2021.
//

import UIKit

class ListTableCell: UITableViewCell {

    @IBOutlet weak var listItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ text: String) {
        self.listItemLabel.text = text.capitalized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

//
//  HistoryTableViewCell.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var contractorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


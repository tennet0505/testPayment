//
//  DetailViewController.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contractorNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var balanceAfterPaymentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var payment: Payment!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        logoImage.image = UIImage(named: payment.contractor.contratorID.logo)
        amountLabel.text = "EUR \(payment.amount)"
        dateLabel.text = payment.datePayment.formatted(date: .complete, time: .shortened)
        contractorNameLabel.text = payment.contractor.contratorID.name
        descriptionLabel.text = payment.description.isEmpty ? "no description" : payment.description
        balanceAfterPaymentLabel.text = "EUR \(payment.balanceAfterPayment)"
        statusLabel.textColor = payment.status.color
        statusLabel.text = payment.status.rawValue
    }
}

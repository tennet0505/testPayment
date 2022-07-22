//
//  DetailViewController.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contractorNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var balanceAfterPaymentLabel: UILabel!
    
    var payment: Payment!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func setup() {
        amountLabel.text = "EUR \(payment.amount)"
        dateLabel.text = payment.datePayment
        contractorNameLabel.text = payment.contracter
        descriptionLabel.text = payment.description.isEmpty ? "no description" : payment.description
        balanceAfterPaymentLabel.text = "EUR \(payment.balanceAfterPayment)"
    }
}

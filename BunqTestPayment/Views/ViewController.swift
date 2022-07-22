//
//  ViewController.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var makePaymentButton: UIButton!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var activityIndacator: UIActivityIndicatorView!
    
    var totalAmount = 0
    
    var storage = Storage()
    var payments: [Payment] = []

    let viewModel = MainViewModel()
    var cancellables = Set<AnyCancellable>()
    let input: PassthroughSubject<Input, Never> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        bind()
        
    }
    
    func bind() {
        
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] output in
                switch output {
                case .didLoadWithFailure(let error):
                    print(error)
                    
                case .didLoadUserWithSiccess(let user):
                    self?.totalAmountLabel.text = "\(user.totalAmount) EUR"
                    self?.payments = user.payments.reversed()
                    self?.tableView.reloadData()
                    
                case .isLoading(let isLoading):
                    self?.makePaymentButton.isEnabled = !isLoading
                    isLoading ? self?.activityIndacator.startAnimating() : self?.activityIndacator.stopAnimating()
                case .didLoadPaymentWithSiccess(users: let payments):
                    self?.payments = payments.reversed()
                    self?.tableView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        input.send(.loadData)
        
    }

    @IBAction func buttonTapAction(_ sender: Any) {
        
        performSegue(withIdentifier: "segueToPayment", sender: self)
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        let payment = payments[indexPath.row]
        cell.nameLabel.text = payment.contractor.contratorID.name
        cell.amountLabel.text = "EUR \(payment.amount)"
        cell.dateLabel.text = payment.datePayment.formatted(date: .abbreviated, time: .shortened)
        cell.contractorImageView.image = UIImage(named: payment.contractor.contratorID.logo)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(payments[indexPath.row])
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.modalPresentationStyle = .formSheet
        vc.payment = payments[indexPath.row]
        self.present(vc, animated: true)
    }
}


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
                case .diLoadWithFailure(let error):
                    print(error)
                    
                case .didLoadUserWithSiccess(let user):
                    self?.totalAmountLabel.text = "\(user.totalAmount) EUR"
                    self?.payments = user.payments
                    self?.tableView.reloadData()
                    
                case .isLoading(let isLoading):
                    self?.makePaymentButton.isEnabled = !isLoading
                    isLoading ? self?.activityIndacator.startAnimating() : self?.activityIndacator.stopAnimating()
                }
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        totalAmountLabel.text = "\(totalAmount) EUR"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let payment = payments[indexPath.row]
        cell.textLabel?.text = "\(payment.amount)"
        return cell
        
    }
}


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
    @IBOutlet weak var gradientView: UIView!
    
    var totalAmount = 0
    
    var storage = Storage()
    var payments: [Payment] = []

    let viewModel = MainViewModel()
    var cancellables = Set<AnyCancellable>()
    let input: PassthroughSubject<Input, Never> = .init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
    }
    
    func setupTableView() {
        gradientView.gradienAlpha()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    @objc func callPullToRefresh(){
        input.send(.loadData(withActivityIndicator: false))
    }
    
    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] output in
                switch output {
                case .didLoadWithFailure(let error):
                    if let alert = self?.alertWithReloadBurron(title: "Error", message: error.localizedDescription, complition: {
                        self?.input.send(.loadData(withActivityIndicator: true))
                    }) {
                        self?.present(alert, animated: true, completion: {
                            self?.tableView.refreshControl?.endRefreshing()
                        })
                    }
                        self?.tableView.reloadData()
                case .didLoadUserWithSuccess(let user):
                    self?.totalAmountLabel.text = "\(user.totalAmount) EUR"
                    self?.payments = user.payments.reversed()
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.tableView.reloadData()
                case .isLoading(let isLoading):
                    self?.makePaymentButton.isEnabled = !isLoading
                    isLoading ? self?.activityIndacator.startAnimating() : self?.activityIndacator.stopAnimating()
                case .didLoadPaymentWithSiccess(users: let payments):
                    self?.payments = payments.reversed()
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.tableView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.loadData(withActivityIndicator: true))
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
        cell.changeColorOfStatusLabel(payment.status)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.modalPresentationStyle = .formSheet
        vc.payment = payments[indexPath.row]
        self.present(vc, animated: true)
    }
}


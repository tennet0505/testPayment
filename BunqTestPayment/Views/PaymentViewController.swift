//
//  PaymentViewController.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import UIKit
import Combine

class PaymentViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var contractorLabel: UITextField!
    
    var storage = Storage()
    let viewModel = PaymentViewModel()
    var cancellables = Set<AnyCancellable>()
    let input: PassthroughSubject<InputPaymentViewModel, Never> = .init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        bind()
        
    }
    
    func bind() {
        amountTextField.becomeFirstResponder()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] output in
                switch output {
                case .didLoadWithFailure(let error):
                    print(error)
                    
                case .didLoadWithSiccess:
                    self?.navigationController?.popViewController(animated: true)
                case .isLoading(let isLoading):
                    self?.payButton.isEnabled = !isLoading
                    self?.view.isUserInteractionEnabled = !isLoading
                    isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                case .showAlert:
                    self?.showAlertWith(message: "Not enough money in the account")
                    self?.amountTextField.becomeFirstResponder()
                }
            }.store(in: &cancellables)
    }

    @IBAction func payButton(_ sender: Any) {
        guard let amount = Double(amountTextField.text ?? ""), let totalAmount = storage.getUser()?.totalAmount else { return }
        if amount < totalAmount  {
            let newPayment = Payment(contracter: "Contractor name", amount: amount, balanceAfterPayment: (totalAmount - amount), datePayment: "\(Date.now)", isPayment: true, description: descriptionLabel.text ?? "")
            input.send(.didNew(newPayment))
        } else {
            input.send(.amountNotCorrect)
        }
    }
}

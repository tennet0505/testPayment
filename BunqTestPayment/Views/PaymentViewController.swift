//
//  PaymentViewController.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import UIKit
import Combine
import iOSDropDown

class PaymentViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var contractorTextField: DropDown!
    
    var storage = Storage()
    let viewModel = PaymentViewModel()
    var cancellables = Set<AnyCancellable>()
    let input: PassthroughSubject<InputPaymentViewModel, Never> = .init()
    var contractorName = ""
    var contractorLogo: ContractorId = .MobileOperator
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = "Payment"
        bind()
        input.send(.getContractorsList)
       
    }
    
    func bind() {

        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] output in
                switch output {
                case .didLoadWithFailure(let error):
                    print(error)
                    
                case .didLoadWithSuccess:
                    self?.navigationController?.popViewController(animated: true)
                case .isLoading(let isLoading):
                    self?.payButton.isEnabled = !isLoading
                    self?.view.isUserInteractionEnabled = !isLoading
                    isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                case .showAlert:
                    self?.showAlertWith(message: "Not enough money in the account")
                    self?.amountTextField.becomeFirstResponder()
                case .didLoadWithSuccessListOf(let contracters):
                    let arrayOfContractors = contracters.map{ $0.contratorID.name }
                    self?.contractorTextField.optionArray = arrayOfContractors
                    self?.contractorTextField.optionIds = [01, 02, 03, 04]
                }
            }.store(in: &cancellables)
        
        contractorTextField.didSelect{ [self](selectedText, index, id) in
            self.contractorName = selectedText
            switch id {
            case 01:
                contractorLogo = .MobileOperator
            case 02:
                contractorLogo = .GasUtilities
            case 03:
                contractorLogo = .ElectroBlueEnergy
            case 04:
                contractorLogo = .ParkingSlot
            default:
                contractorLogo = .defaultLogo
            }
        }
    }

    @IBAction func payButton(_ sender: Any) {
        guard let amount = Double(amountTextField.text ?? ""), let totalAmount = storage.getUser()?.totalAmount else { return }
        if amount < totalAmount  {
            let newPayment = Payment(contractor: Contrator(contratorID: contractorLogo),
                                     amount: amount,
                                     balanceAfterPayment: (totalAmount - amount),
                                     datePayment: Date.now,
                                     isPayment: true,
                                     description: descriptionLabel.text ?? "")
            input.send(.didNew(newPayment))
        } else {
            input.send(.amountNotCorrect)
        }
    }
}

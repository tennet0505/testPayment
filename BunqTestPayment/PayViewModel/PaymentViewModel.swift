//
//  PaymentViewModel.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation
import Combine


enum InputPaymentViewModel {
    case didNew(_ payment: Payment)
    case amountNotCorrect
    case getContractorsList
}

enum OutputPaymentViewModel {
    case didLoadWithFailure(error: Error)
    case didLoadWithSuccess
    case isLoading(Bool)
    case showAlert
    case didLoadWithSuccessListOf(contracters: [Contrator])
}

class PaymentViewModel {
    
    let outputPaymentViewModel: PassthroughSubject<OutputPaymentViewModel, Never> = .init()
    //DI
    var apiService: ServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(apiService: ServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    func transform(input: AnyPublisher<InputPaymentViewModel, Never>) -> AnyPublisher<OutputPaymentViewModel, Never> {
      
        input.sink { [weak self] input in
            switch input {
            case .didNew(let payment):
                self?.postNew(payment)
            case .amountNotCorrect:
                self?.outputPaymentViewModel.send(.showAlert)
            case .getContractorsList:
                self?.getContractors()
            }
        }.store(in: &cancellables)
        
        return outputPaymentViewModel.eraseToAnyPublisher()
    }
    
    func getContractors() {
        outputPaymentViewModel.send(.isLoading(true))
        apiService.getContractorsList()
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    self?.outputPaymentViewModel.send(.didLoadWithFailure(error: error))
                case .finished:
                    self?.outputPaymentViewModel.send(.isLoading(false))
                }
            } receiveValue: { [weak self] contracters in
                self?.outputPaymentViewModel.send(.didLoadWithSuccessListOf(contracters: contracters))
               
            }.store(in: &cancellables)
    }
    
    func postNew(_ payment: Payment) {
        outputPaymentViewModel.send(.isLoading(true))
        apiService.postNew(payment)
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    self?.outputPaymentViewModel.send(.didLoadWithFailure(error: error))
                case .finished:
                    self?.outputPaymentViewModel.send(.isLoading(false))
                }
            } receiveValue: { [weak self] user in
                self?.outputPaymentViewModel.send(.didLoadWithSuccess)
               
            }.store(in: &cancellables)
    }
}

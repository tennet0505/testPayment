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
}

enum OutputPaymentViewModel {
    case didLoadWithFailure(error: Error)
    case didLoadWithSiccess
    case isLoading(Bool)
    case showAlert
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
            }
        }.store(in: &cancellables)
        
        return outputPaymentViewModel.eraseToAnyPublisher()
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
                self?.outputPaymentViewModel.send(.didLoadWithSiccess)
               
            }.store(in: &cancellables)
    }
}

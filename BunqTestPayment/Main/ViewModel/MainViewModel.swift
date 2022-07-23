//
//  MainViewModel.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation
import Combine

enum Input {
    case loadData(withActivityIndicator: Bool)
    case loadPayments
}

enum Output {
    case didLoadWithFailure(error: Error)
    case didLoadUserWithSuccess(users: User)
    case didLoadPaymentWithSiccess(users: [Payment])
    case isLoading(Bool)
}

class MainViewModel {
    
    let output: PassthroughSubject<Output, Never> = .init()
    //DI
    var apiService: ServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(apiService: ServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
      
        input.sink { [weak self]input in
            switch input {
            case .loadData(let withActivityIndicator):
                self?.getUser(withActivityIndicator)
            case.loadPayments:
                self?.getPayments()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func getUser(_ withActivityIndicator: Bool) {
        output.send(.isLoading(withActivityIndicator))
        apiService.getUser()
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    self?.output.send(.isLoading(false))
                    self?.output.send(.didLoadWithFailure(error: error))
                case .finished:
                    self?.output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] user in
                self?.output.send(.didLoadUserWithSuccess(users: user))
            }.store(in: &cancellables)
    }
    
    func getPayments() {
        output.send(.isLoading(true))
        apiService.fetchAllPayments()
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    self?.output.send(.didLoadWithFailure(error: error))
                    self?.output.send(.isLoading(false))
                case .finished:
                    self?.output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] payments in
                self?.output.send(.didLoadPaymentWithSiccess(users: payments))
               
            }.store(in: &cancellables)
    }
    
}

enum ApiError: Error {
    case response
    case noData
    case serverNoAnswer
}


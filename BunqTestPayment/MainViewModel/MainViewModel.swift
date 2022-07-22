//
//  MainViewModel.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation
import Combine

enum Input {
    case loadData
    case loadPayments
}

enum Output {
    case didLoadWithFailure(error: Error)
    case didLoadUserWithSiccess(users: User)
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
            case .loadData:
                self?.getUser()
            case.loadPayments:
                self?.getPayments()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func getUser() {
        output.send(.isLoading(true))
        apiService.getUser()
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    self?.output.send(.didLoadWithFailure(error: error))
                case .finished:
                    self?.output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] user in
                self?.output.send(.didLoadUserWithSiccess(users: user))
               
            }.store(in: &cancellables)
    }
    
    func getPayments() {
        output.send(.isLoading(true))
        apiService.fetchAllPayments()
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    self?.output.send(.didLoadWithFailure(error: error))
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
}


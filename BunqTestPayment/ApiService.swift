//
//  ApiService.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation
import Combine

protocol ServiceProtocol {
    func fetchAllPayments() -> AnyPublisher<[Payment], Error>
    func getUser() -> AnyPublisher<User, Error>
    func fetchTotalAmount()
    func postNew(payment: Payment)
   
}

class ApiService: ServiceProtocol {
    let storage = Storage()

    func fetchAllPayments() -> AnyPublisher<[Payment], Error>  {
        
        let payments = self.storage.getPayments()
        return  Just(payments)
            .delay(for: 1, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<User, Error> {
        guard let user = self.storage.getUser() else {
            return Fail(error: ApiError.noData).eraseToAnyPublisher()
        }
        return  Just(user)
            .delay(for: 1, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchTotalAmount() {
        
    }
    
    func postNew(payment: Payment) {
        
        storage.save(payment)
    }
}


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
    func getContractorsList() -> AnyPublisher<[Contrator], Error>
    func postNew(_ payment: Payment) -> AnyPublisher<[Payment], Error>
   
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
        let randomInt = Int.random(in: 1...5)
        print(randomInt)
        if randomInt == 4 {
            return Fail(error: ApiError.noData).eraseToAnyPublisher()
        } else {
        return  Just(user)
            .delay(for: 1, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
    }
    
    func getContractorsList() -> AnyPublisher<[Contrator], Error> {
        let contrators = self.storage.getContractors()
        return  Just(contrators)
            .delay(for: 1, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func postNew(_ payment: Payment) -> AnyPublisher<[Payment], Error> {
        
        storage.save(payment)
        
        let payments = self.storage.getPayments()
        return  Just(payments)
            .delay(for: 1, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


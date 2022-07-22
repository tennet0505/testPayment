//
//  Storage.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation

// mock storage API Service
class Storage {
    
    weak var shared: Storage?
    var storage = UserDefaults()    
    
    func mock(_ user: User) {
        
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "User")
            }
            
            if let encoded = try? encoder.encode(user.payments) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SavePayments")
        }
    }
    
    func mock(_ contractors: [Contrator]) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contractors) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Contrator")
        }
    }
    
    func save(_ payment: Payment) {
        var payments = getPayments()
        payments.append(payment)
        if var user = getUser() {
            let amountAfterPayment = user.totalAmount - payment.amount
            user.totalAmount = amountAfterPayment
            user.payments = payments
            mock(user)
        }
    }
    
    func getPayments() -> [Payment]{
        guard let allPayments = storage.object(forKey: "SavePayments") as? Data,
                let payments = try? JSONDecoder().decode([Payment].self, from: allPayments) else {
            return []
        }
        return payments
    }
    
    func getContractors() -> [Contrator]{
        guard let allContrators = storage.object(forKey: "Contrator") as? Data,
                let contractors = try? JSONDecoder().decode([Contrator].self, from: allContrators) else {
            return []
        }
        return contractors
    }
    
    func getUser() -> User? {
        guard let user = storage.object(forKey: "User") as? Data,
                let user = try? JSONDecoder().decode(User.self, from: user) else {
            return nil
        }
        return user
    }
}


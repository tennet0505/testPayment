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
        
        if getPayments().isEmpty {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user.payments) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SavePayments")
            }
        }
    }
    
    func save(_ payment: Payment) {
        var payments = getPayments()
        payments.append(payment)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(payments) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavePayments")
        }
    }
    
    func getPayments() -> [Payment]{
        guard let allPayments = storage.object(forKey: "SavePayments") as? Data,
                let payments = try? JSONDecoder().decode([Payment].self, from: allPayments) else {
            return []
        }
        return payments
    }
    
    func getUser() -> User? {
        guard let user = storage.object(forKey: "User") as? Data,
                let user = try? JSONDecoder().decode(User.self, from: user) else {
            return nil
        }
        return user
    }
}


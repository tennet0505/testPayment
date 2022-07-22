//
//  Models.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation

struct User: Decodable, Encodable {
    
    var userID: Int
    var totalAmount: Int
    var payments: [Payment]
    
}

struct Payment: Decodable, Encodable {
    var contracter: String
    var amount: String
    var datePayment: String
    var isPayment: Bool
}

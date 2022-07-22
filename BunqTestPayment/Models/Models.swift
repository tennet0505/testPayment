//
//  Models.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation

struct User: Decodable, Encodable {
    var userID: Int
    var totalAmount: Double
    var payments: [Payment]
}

struct Payment: Decodable, Encodable {
    var contractor: Contrator
    var amount: Double
    var balanceAfterPayment: Double
    var datePayment: Date
    var isPayment: Bool
    var description: String
}

struct Contrator: Decodable, Encodable {
    var contratorID: ContractorId
}

enum ContractorId: String, Encodable, Decodable {
    case MobileOperator
    case GasUtilities
    case ElectroBlueEnergy
    case ParkingSlot
    case defaultLogo
    
    var name: String {
        switch self {
        case .MobileOperator:
            return "Mobile Operator"
        case .GasUtilities:
            return "Gas Utilities"
        case .ElectroBlueEnergy:
            return "Electro Blue Energy"
        case .ParkingSlot:
            return "Parking Slot"
        case .defaultLogo:
            return "Utilities"
        }
    }

    var logo: String {
        switch self {
        case .MobileOperator:
            return "logo3"
        case .GasUtilities:
            return "logo4"
        case .ElectroBlueEnergy:
            return "logo6"
        case .defaultLogo:
            return "defaultLogo"
        case .ParkingSlot:
            return "logo5"
        }
    }
}

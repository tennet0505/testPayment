//
//  Models.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation
import UIKit

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
    var isPayed: Bool
    var description: String
    var status: Status
}

struct Contrator: Decodable, Encodable {
    var contratorID: ContractorId
}

enum Status: String, Encodable, Decodable {
    case approved
    case pending
    case cancelled
    
    var color: UIColor {
        switch self {
        case .approved:
            return .systemGreen.withAlphaComponent(0.6)
        case .pending:
            return .orange.withAlphaComponent(0.6)
        case .cancelled:
            return .red.withAlphaComponent(0.6)
        }
    }
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

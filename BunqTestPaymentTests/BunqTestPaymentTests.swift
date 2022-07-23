//
//  BunqTestPaymentTests.swift
//  BunqTestPaymentTests
//
//  Created by Oleg Ten on 22/07/2022.
//

import XCTest
import Combine
@testable import BunqTestPayment

class BunqTestPaymentTests: XCTestCase {

    var sut: MainViewModel!
    var serviceAPI: MockApiService!
    var cancellable = Set<AnyCancellable>()
    var payments: [Payment] = []
    var user: User!
    var contractors: [Contrator] = []
    
    override func setUpWithError() throws {
        serviceAPI = MockApiService()
        sut = MainViewModel(apiService: serviceAPI)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        serviceAPI = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testExampleSuccess() {
        //given
        serviceAPI.publisher = Just([Payment(contractor:
                                                Contrator(contratorID: .GasUtilities),
                                              amount: 200.3,
                                              balanceAfterPayment: 20000,
                                              datePayment: Date.distantPast,
                                              isPayment: true,
                                              description: "Payment for mobile service"),
                                      Payment(contractor:
                                                Contrator(contratorID: .MobileOperator),
                                              amount: 300.4,
                                              balanceAfterPayment: 20000,
                                              datePayment: Date.now,
                                              isPayment: true,
                                              description: "")]
                )
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
        //when
        serviceAPI.fetchAllPayments().sink { error in
            print(error)
        } receiveValue: { payments in
            self.payments = payments
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(payments[0].amount, 200.3)
        XCTAssertEqual(payments.count, 2)
        
        //---------------------
        //given
        serviceAPI.userPublisher = Just(User(userID: 1,
                                      totalAmount: 20000,
                                      payments: [Payment(contractor:
                                                            Contrator(contratorID: .MobileOperator),
                                                         amount: 300.4,
                                                         balanceAfterPayment: 20000,
                                                         datePayment: Date.now,
                                                         isPayment: true,
                                                         description: "")]))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        //when
        serviceAPI.getUser().sink { error in
            print(error)
        } receiveValue: { user in
            self.user = user
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(user.totalAmount, 20000)
        XCTAssertTrue(user.payments[0].isPayment)
        
        //---------------------
        //given
        serviceAPI.contractorPublisher = Just([Contrator(contratorID: .MobileOperator),
                                                 Contrator(contratorID: .ElectroBlueEnergy),
                                                 Contrator(contratorID: .GasUtilities),
                                                 Contrator(contratorID: .ParkingSlot)])
                     .setFailureType(to: Error.self)
                     .eraseToAnyPublisher()
        
        //when
        serviceAPI.getContractorsList().sink { error in
            print(error)
        } receiveValue: { contractors in
            self.contractors = contractors
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(contractors.count, 4)
        XCTAssertTrue(contractors[0].contratorID == .MobileOperator)
        
        //---------------------
        //given
        serviceAPI.contractorPublisher = Just([Contrator(contratorID: .MobileOperator),
                                                 Contrator(contratorID: .ElectroBlueEnergy),
                                                 Contrator(contratorID: .GasUtilities),
                                                 Contrator(contratorID: .ParkingSlot)])
                     .setFailureType(to: Error.self)
                     .eraseToAnyPublisher()
        
        //when
        
        serviceAPI.publisher = Just([Payment(contractor:
                                                Contrator(contratorID: .GasUtilities),
                                              amount: 200.3,
                                              balanceAfterPayment: 20000,
                                              datePayment: Date.distantPast,
                                              isPayment: true,
                                              description: "Payment for mobile service"),
                                      Payment(contractor:
                                                Contrator(contratorID: .MobileOperator),
                                              amount: 300.4,
                                              balanceAfterPayment: 20000,
                                              datePayment: Date.now,
                                              isPayment: true,
                                              description: "")]
                )
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
        
        let payment: Payment = Payment(contractor:
                                        Contrator(contratorID: .MobileOperator),
                                     amount: 340.4,
                                     balanceAfterPayment: 10000,
                                     datePayment: Date.now,
                                     isPayment: true,
                                     description: "")
        
        serviceAPI.postNew(payment).sink { error in
            print(error)
        } receiveValue: { payments in
            self.payments = payments
            self.payments.append(payment)
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(payments.count, 3)
        XCTAssertEqual(payments.last?.amount, 340.4)
    }
    
    func testExampleFailure() {
        //given
        serviceAPI.publisher = Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        //when
        serviceAPI.fetchAllPayments().sink { error in
            print(error)
        } receiveValue: { payments in
            self.payments = payments
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(payments.count, 0)
        
        //-----------------
        //given
        serviceAPI.userPublisher = Just(User(userID: 0, totalAmount: 0, payments: []))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        //when
        serviceAPI.getUser().sink { error in
            print(error)
        } receiveValue: { user in
            self.user = user
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(payments.count, 0)
        
        //-----------------
        //given
        serviceAPI.contractorPublisher = Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        //when
        serviceAPI.getContractorsList().sink { error in
            print(error)
        } receiveValue: { contractors in
            self.contractors = contractors
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(payments.count, 0)
        
        //-----------------
        //given
        serviceAPI.contractorPublisher = Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        //when
       let payment: Payment = Payment(contractor:
                                        Contrator(contratorID: .MobileOperator),
                                     amount: 340.4,
                                     balanceAfterPayment: 10000,
                                     datePayment: Date.now,
                                     isPayment: false,
                                     description: "")
        
        serviceAPI.postNew(payment).sink { error in
            print(error)
        } receiveValue: { payments in
            self.payments = payments
        }.store(in: &cancellable)

        //then
        XCTAssertEqual(payments.count, 0)
    }
}

class MockApiService: ServiceProtocol {
    
    var publisher: AnyPublisher<[Payment], Error>?
    func fetchAllPayments() -> AnyPublisher<[Payment], Error> {
        return publisher!
    }
    
    var userPublisher: AnyPublisher<User, Error>?
    func getUser() -> AnyPublisher<User, Error> {
        return userPublisher!
    }
    
    var contractorPublisher: AnyPublisher<[Contrator], Error>?
    func getContractorsList() -> AnyPublisher<[Contrator], Error> {
        return contractorPublisher!
    }
    
    func postNew(_ payment: Payment) -> AnyPublisher<[Payment], Error> {
        return publisher!
    }
}

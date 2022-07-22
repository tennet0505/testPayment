//
//  SceneDelegate.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //mock Data
        let payments: [Payment] = [Payment(contractor:
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
        
        let contractors: [Contrator] = [Contrator(contratorID: .MobileOperator),
                                        Contrator(contratorID: .GasUtilities),
                                        Contrator(contratorID: .ElectroBlueEnergy),
                                        Contrator(contratorID: .ParkingSlot)]
        let user: User = User(userID: 1, totalAmount: 20000, payments: payments)
        let storage = Storage()
        storage.mock(user)
        storage.mock(contractors)
        //mock Data
    
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


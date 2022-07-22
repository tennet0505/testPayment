//
//  Helpers.swift
//  BunqTestPayment
//
//  Created by Oleg Ten on 22/07/2022.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showAlertWith(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

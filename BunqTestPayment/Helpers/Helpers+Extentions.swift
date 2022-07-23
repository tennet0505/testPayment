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
    
    func alertWithReloadBurron(title: String = "", message: String, complition: @escaping() -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let reload = UIAlertAction(title:"Reload", style: .default) { _ in
            complition()
        }
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel))
        alert.addAction(reload)
        return alert
    }
}

extension UIView {

    func gradienAlpha(){
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.6).cgColor, whiteColor.withAlphaComponent(0.9).cgColor]
        gradient.locations = [ 0.0, 1.0]
        gradient.frame = self.bounds
        self.layer.mask = gradient
    }
}

extension Array {
    
    mutating func modifyForEach(_ body: (_ index: Index, _ element: inout Element) -> ()) {
        for index in indices {
            modifyElement(atIndex: index) { body(index, &$0) }
        }
    }
    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> ()) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
}

extension Double {

    func formatAsCurrency(_ currencyCode: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.maximumFractionDigits = floor(self) == self ? 0 : 2
        return currencyFormatter.string(from: self as NSNumber)
    }
}

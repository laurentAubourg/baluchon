//
//  ViewController+Alert.swift
//  baluchon
//
//  Created by laurent aubourg on 23/09/2021.
//

import Foundation
import UIKit

extension UIViewController{
    
    //MARK: - Displays an alert
    
   internal func presentAlert(_ message:String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

//
//  ConvertViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

class ConvertViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var rateLab: UILabel!
    @IBOutlet weak var valueIn: UITextField!
    
    @IBOutlet weak var valueOut: UILabel!
    private let service:CurrencyConverterService = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    private func update(currencyVO: FixerResponse) {
        guard !valueIn.text!.isEmpty else{
            self.valueOut.text = "0"
            return
            
        }
        guard  let  valIn = Double(valueIn.text!) else{
            self.valueIn.text = ""
            self.valueOut.text = "0"
            return}
        let tempVar = Double(valIn) * currencyVO.rates.usd
        self.rateLab.text = " Rate: \(String(currencyVO.rates.usd))"
        self.valueOut.text = String(format: "%.2f", tempVar)
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The rate download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        valueIn.resignFirstResponder()
    }
    @IBAction func textChanged(_ sender: UITextField) {
        
        service.getRate{ result in
            DispatchQueue.main.async {
                switch result {
                case .success( let data):
                    self.update(currencyVO: data)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}

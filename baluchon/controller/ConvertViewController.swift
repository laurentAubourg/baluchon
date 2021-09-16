//
//  ConvertViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

class ConvertViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var valueInTextField: UITextField!
    
    @IBOutlet weak var valueOutLabel: UILabel!
    private let service:CurrencyConverterService = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textserviceFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    private func update(currencyVO: FixerResponse) {
        guard !valueInTextField.text!.isEmpty else{
            self.valueOutLabel.text = "0"
            return
            
        }
        guard  let  valIn = Double(valueInTextField.text!) else{
            self.valueInTextField.text = ""
            self.valueOutLabel.text = "0"
            return}
        let tempVar = Double(valIn) * currencyVO.rates.usd
        self.rateLabel.text = " Rate: \(String(currencyVO.rates.usd))"
        self.valueOutLabel.text = String(format: "%.2f", tempVar)
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The rate download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        valueInTextField.resignFirstResponder()
    }
    @IBAction func textChanged(_ sender: UITextField) {
        
        service.getRate{  [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success( let data):
                    print (data)
                    self?.update(currencyVO: data)
                case .failure(let error):
                    print(error)
                }
            }
            
            
        }
        service.getRate{ result in
            DispatchQueue.main.async {
                switch result {
                case .success( let data):
                    print (data)
                    self.update(currencyVO: data)
                case .failure(let error):
                    print(error)
                }
            }
            
            
        }
    }
}

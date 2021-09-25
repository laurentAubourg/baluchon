//
//  ConvertViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

final class ConvertViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - @IBOUTLETS
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var valueInTextField: UITextField!
    
    @IBOutlet weak var valueOutLabel: UILabel!
    
    //MARK: - Properties
    
    private let service:CurrencyService = .init()
    private var rate:Double = 0.0
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGradient(gradientColors: [UIColor.black.cgColor,UIColor.blue.cgColor])
    }
    override func viewWillAppear(_ animated: Bool) {
       // getRate()
    }
    
    // MARK: Make a call to the model to get the exchange rate
    
    private func getRate(){
        service.getRate{  [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success( let data):
                    self!.rate = data.rates.usd
                    
                case .failure( let error):
                    self?.presentAlert("The rate download failed :\(error)")
                } } }
        
    }
    
    //MARK: - Hides the keyboard when tapping on the view
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        valueInTextField.resignFirstResponder()
    }
    
    // MARK: - Calculates and displays the converted value in euro
    
    /* when text input change multiplies the value entered in euros by the exchange rate to obtain the value in dollars and displays it
     */
    
    @IBAction func textChanged(_ sender: UITextField) {
        
        guard !valueInTextField.text!.isEmpty else{
            self.valueOutLabel.text = "0"
            return
            
        }
        guard  let  valIn = Double(valueInTextField.text!) else{
            self.valueInTextField.text = ""
            self.valueOutLabel.text = "0"
            return}
        let tempVar = Double(valIn) * self.rate
        self.rateLabel.text = " Rate: \(String(self.rate))"
        self.valueOutLabel.text = String(format: "%.2f", tempVar)
    }
}

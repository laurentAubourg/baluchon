//
//  TranslateViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

class TranslateViewController: UIViewController,UITextFieldDelegate {
   
    
    @IBOutlet weak var tanslateTextView: UITextView!
    @IBOutlet weak var toTranslatTextView: UITextView!
    
    private let service:TranslatorService = .init()
    
    @IBOutlet weak var langageTableView: UITableView!
    @
    IBOutlet weak var langageChoiceButton: UIButton!
    var languageArray :[[String:String]]{
        service.languageArray;
    }
   
    var currentLang:String{
        get{
        service.currentLang
        }
        set{
            service.currentLang = newValue
            langageTableView.reloadData()
            translateTapped(nil)
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        langageTableView.delegate = self
        langageTableView.dataSource = self
        currentLang = "EN-GB"
      //testCancel()
        
        
    }
    
    func testCancel(){
        for  i in 1 ... 100{
            toTranslatTextView.text = "bonjour \(i)"
            translateTapped(nil)
        }
    }
   
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        toTranslatTextView.resignFirstResponder()
       let tapGestureRecognizer = sender
      
          tapGestureRecognizer.cancelsTouchesInView = false
        hidelangageTableView()
       
    }
    func hidelangageTableView(){
        langageTableView.isHidden = true
    }
    @IBAction func translateTapped(_ sender: UIButton?) {
        guard  let text = toTranslatTextView.text  else{ return }
  //      testCancel()
        service.translate(textToTranslate: text){ [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success( let data):
                    print (data)
                    self?.tanslateTextView.text = data.translations[0].text
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    @IBAction func languageButtonTapped(_ sender: Any) {
        langageTableView.isHidden  = !langageTableView.isHidden
    }
}

//MARK : - UITableViewDelegate Extension
extension TranslateViewController:UITableViewDelegate {
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let line: [String:String] = languageArray[indexPath.row]
        let symbol = line["short"]!
            currentLang = symbol
        hidelangageTableView()
        langageChoiceButton.setTitle(line["name"],for: .normal)
    }
}
extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        languageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = langageTableView.dequeueReusableCell(withIdentifier: "cell")!
        let line: [String:String] = languageArray[indexPath.row]
        let symbole = line["short"]!
     
       if symbole == currentLang {
        cell.imageView?.image = UIImage(named: "valid")
       }else{
        cell.imageView?.image = nil
       }
     
        cell.textLabel?.text = line["name"]
        
   //  cell.langCellLabel.text = line["name"]
        
        return cell
    }
 
}

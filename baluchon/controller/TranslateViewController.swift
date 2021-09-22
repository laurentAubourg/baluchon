//
//  TranslateViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

class TranslateViewController: UIViewController,UITextFieldDelegate {
   
    
    @IBOutlet weak var iconButtonListLangagaButton: UIButton!
    @IBOutlet weak var tanslateTextView: UITextView!
    @IBOutlet weak var toTranslatTextView: UITextView!
    
    private let service:TranslatorService = .init()
    
    @IBOutlet weak var langageTableView: UITableView!
    @
    IBOutlet weak var langageChoiceButton: UIButton!
    var languageArray :[Target]{
        service.languageArray
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
        view.addGradient(gradientColors: [UIColor.black.cgColor,UIColor.blue.cgColor])
       
        langageTableView.delegate = self
        langageTableView.dataSource = self
        currentLang = "EN-GB"
     langageChoiceButton.setTitle("[ \(currentLang))] select a language ",for: .normal)
     
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
        langageTableViewIsHidden(state:true)
        
       
    }
   
    @IBAction func translateTapped(_ sender: UIButton?) {
        guard  let text = toTranslatTextView.text  else{ return }
  //      testCancel()
        service.translate(textToTranslate: text){ [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success( let data):
                    
                    self?.tanslateTextView.text = data.translations[0].text
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    @IBAction func languageButtonTapped(_ sender: Any) {
        langageTableViewIsHidden(state:!langageTableView.isHidden)
        
    }

   private func  moveIconListLangagaButton(){
          if (!langageTableView.isHidden){
            iconButtonListLangagaButton.setImage(UIImage(named: "arrowDown"), for: .normal)
          }else{
              iconButtonListLangagaButton.setImage(UIImage(named: "arrowRight"), for: .normal)
          }
      }
    private func langageTableViewIsHidden(state:Bool){
        langageTableView.isHidden = state
        moveIconListLangagaButton()
    }

}
//MARK : - UITableViewDelegate Extension
extension TranslateViewController:UITableViewDelegate {
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let line: Target = (languageArray[indexPath.row])
        let symbol = line.language
            currentLang = symbol
        langageTableViewIsHidden(state:true)
        langageChoiceButton.setTitle("[ \(String(describing: symbol)) ] select a language ",for: .normal)
    }
}
extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return languageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = langageTableView.dequeueReusableCell(withIdentifier: "cell")!
        let  line: Target = service.languageArray[indexPath.row]
        let symbole = line.language
     
       if symbole == currentLang {
        cell.imageView?.image = UIImage(named: "valid")
       }else{
        cell.imageView?.image = nil
       }
     
        cell.textLabel?.text = line.name
        
   //  cell.langCellLabel.text = line["name"]
        
        return cell
    }
 
}

//
//  TranslateViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

final class TranslateViewController: UIViewController,UITextFieldDelegate {
 
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var iconButtonListLangagaButton: UIButton!
    @IBOutlet weak var tanslateTextView: UITextView!
    @IBOutlet weak var toTranslatTextView: UITextView!
    @IBOutlet weak var langageTableView: UITableView!
    @IBOutlet weak var langageChoiceButton: UIButton!
    
    //MARK: - Properties
    
    private let service:TranslatorService = .init()
    private var languageArray :[Target]{
        service.languageArray
    }
    private var currentLang:String{
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
    
  /*
    private func testCancel(){
        for  i in 1 ... 100{
            toTranslatTextView.text = "bonjour \(i)"
            translateTapped(nil)
        }
    }
   */
    
    //MARK: - Hides the keyboard when tapping on the view
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        toTranslatTextView.resignFirstResponder()
        
        let tapGestureRecognizer = sender
        
        tapGestureRecognizer.cancelsTouchesInView = false
        langageTableViewIsHidden(state:true)
        
        
    }
    //MARK: - Ask the model to translate the text after clicking on the TRANSLATE button
    
    @IBAction func translateTapped(_ sender: UIButton?) {
        guard  let text = toTranslatTextView.text  else{ return }
        //      testCancel()
        service.translate(textToTranslate: text){ [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success( let data):
                    
                    self?.tanslateTextView.text = data.translations[0].text
                case .failure(let error):
                    self?.presentAlert("The translate download failed :\(error)")
                }
            }
            
        }
    }
    
    //MARK: Displays the TableView containing the list of available languages
    
    @IBAction func languageButtonTapped(_ sender: Any) {
        langageTableViewIsHidden(state:!langageTableView.isHidden)
        
    }
    private func langageTableViewIsHidden(state:Bool){
        langageTableView.isHidden = state
        moveIconListLangagaButton()
    }
    
    // MARK: -Changes the arrow of the button when the view is hidden or visible
    
    private func  moveIconListLangagaButton(){
        if (!langageTableView.isHidden){
            iconButtonListLangagaButton.setImage(UIImage(named: "arrowDown"), for: .normal)
        }else{
            iconButtonListLangagaButton.setImage(UIImage(named: "arrowRight"), for: .normal)
        }
    }

    
}

//MARK: - TranslateViewController:UITableViewDelegate Extension

extension TranslateViewController:UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let line: Target = (languageArray[indexPath.row])
        let symbol = line.language
        currentLang = symbol
        langageTableViewIsHidden(state:true)
        langageChoiceButton.setTitle("[ \(String(describing: symbol)) ] select a language ",for: .normal)
    }
}

//MARK: - UITableViewDataSource Extension

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

//
//  WeatherViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - @IBOUTLETS
    
    @IBOutlet weak var tempMontreuilLabel: UILabel!
    @IBOutlet weak var tempNewYorkLabel: UILabel!
    @IBOutlet weak var iconWeatherMontreuilImage: UIImageView!
    @IBOutlet weak var iconWeatherNewYoykImage: UIImageView!
    @IBOutlet weak var weatherDescriptionMontreuilLabel: UILabel!
    @IBOutlet weak var weatherDescriptionNewYorkLabel: UILabel!
   
    //MARK: - Properties
    
    private let service:WeatherService = .init()
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGradient(gradientColors: [UIColor.black.cgColor,UIColor.blue.cgColor])
    }
    
    // MARK: - Request the weather from the OpenWeather API when displaying the view
    
    override func viewWillAppear(_ animated: Bool) {
        getWeather()
    }
    private func getWeather(){
        service.getWeather(callback:{ result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success( let data):
                    self?.iconWeatherMontreuilImage.image = UIImage(named: self?.iconName(data:data, cityNumber:1) ?? "")
                    self?.iconWeatherNewYoykImage.image = UIImage(named: self?.iconName(data:data, cityNumber:0) ??  "")
                    self!.weatherDescriptionNewYorkLabel.text = self?.description(data: data, cityNumber: 0)
                    self?.weatherDescriptionMontreuilLabel.text = self?.description(data: data, cityNumber: 1)
                    self?.tempNewYorkLabel.text = ("\(self?.Temperature(data: data, cityNumber: 0) ?? "?") °C")
                    self?.tempMontreuilLabel.text = ("\(self?.Temperature(data: data, cityNumber: 1) ?? "?") °C")
                   // print(iconeName(data:data, cityNumber:1))
                
                case .failure(let error):
                    self?.presentAlert("The weather download failed.:\(error)")
                }
            }
            
        })
      
    }
    
    //MARK: - Displays the weather status icon
    
    private func  iconName(data:WeatherResponse, cityNumber:Int = 0)->String{
        guard  (data.list[cityNumber].weather[0].icon) != nil else{return "none"}
        return data.list[cityNumber].weather[0].icon!
    }
    
    //MARK: - Displays the weather status textual description under icon
    
    private func  description(data:WeatherResponse, cityNumber:Int = 0)->String{
        guard  (data.list[cityNumber].weather[0].weatherDescription) != nil else{return "none"}
        return data.list[cityNumber].weather[0].weatherDescription!
    }
    
    //MARK: - Displays the temperature value
    
    private func  Temperature(data:WeatherResponse, cityNumber:Int = 0)->String{
        
        return String(Int(data.list[cityNumber].main.temp) )
    }
    
   

}

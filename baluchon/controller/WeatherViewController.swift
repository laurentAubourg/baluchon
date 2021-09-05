//
//  WeatherViewController.swift
//  baluchon
//
//  Created by laurent aubourg on 25/08/2021.
//

import UIKit

class WeatherViewController: UIViewController {
    private let service:WeatherService = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getWeather(callback:{ result in
            DispatchQueue.main.async {
                switch result {
                case .success( let data):
                  print(data)
                case .failure(let error):
                    print(error)
                }
            }
            
        })
        // Do any additional setup after loading the view.
    }
    

   

}

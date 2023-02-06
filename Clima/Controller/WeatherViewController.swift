//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    // UITextFieldDelegate is a protocol
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchTextField.delegate = self // soft keyboard can return
        weatherManager.delegate = self
        
    }
    
    @IBAction func searchPressed(_ sender: UITextField) {
        searchTextField.endEditing(true) // display the soft keyboard
        print(searchTextField.text!)
    }
    
    // return on the keyboard should de the same thing as search does
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"    // remind user to type a city name before search
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityname: city)
            
        }
        
        searchTextField.text = ""
    }
    func didUpdateWeather(_ data: WeatherModel) {
        DispatchQueue.main.async {
            print(data.temperatureString)
            self.temperatureLabel.text = data.temperatureString
            self.cityLabel.text = data.cityname
            print("well done")
        }
    }
}


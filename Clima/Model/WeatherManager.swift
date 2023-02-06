//
//  WeatherManager.swift
//  Clima
//
//  Created by Yujun Zhao on 1/13/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ data:WeatherModel)
}

struct WeatherManager {
    // lec148: api
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8c4042c001ce8d5d45b5c5cf8dea955d&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityname: String) {
        let city = cityname.replacingOccurrences(of: " ", with: "+")
        print("output of fetchWeather", city)
        let urlString = "\(weatherURL)&q=\(city)"
        self.performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. creat a URL
        if let url = URL(string: urlString) {
            // 2. create URlsession
            let session = URLSession(configuration: .default)
            //3. give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in // closure
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safedata = data {
                    if let weather = self.parseJSON(safedata) {
                        self.delegate?.didUpdateWeather(weather)
                        
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionalId: id, cityname: name, temperature: temp)
            print(weather.conditionName)
            
            return weather
        } catch {
            print(error)
            return nil
        }
    }
    
}


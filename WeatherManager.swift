//
//  WeatherManager.swift
//  Clima
//
//  Created by moboustt on 11/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=cb117dc901f934c944744aee329d81ff&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        // Create url
        if let url = URL(string: urlString) {
            // Create a URLSession
            let session = URLSession(configuration: .default)
            
            // Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch  {
            print("ERROR: \(error)")
            return nil
        }
    }
}

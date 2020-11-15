//
//  WeatherManager.swift
//  Clima
//
//  Created by moboustt on 11/14/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

protocol WeatherMangerDelegate {
    func didUpdateWeatherManager(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=cb117dc901f934c944744aee329d81ff&units=metric"
    
    var delegate: WeatherMangerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude lat: Float , longitude lon: Float){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Create a URL
        if let url = URL(string: urlString) {
            // Create a URLsession
            let session = URLSession(configuration: .default)
            
            // Create a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeatherManager(self, weather: weather)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            return WeatherModel(cityName: name, conditionID: id, temperature: temp)

        } catch  {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

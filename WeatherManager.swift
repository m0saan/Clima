//
//  WeatherManager.swift
//  Clima
//
//  Created by moboustt on 11/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=cb117dc901f934c944744aee329d81ff&units=metric"
    
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
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString)
                }
            }
            
            // Start the task
            task.resume()
        }
    }

}

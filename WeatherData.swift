//
//  WeatherModel.swift
//  Clima
//
//  Created by moboustt on 11/14/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Float
}

struct Weather: Decodable {
    let id: Int
}

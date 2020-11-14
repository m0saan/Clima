//
//  WeatherData.swift
//  Clima
//
//  Created by moboustt on 11/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

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

//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManger = WeatherManager()
    let locationManager = CLLocationManager()
    
    var lat: Float = 0.0
    var lon: Float = 0.0
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var textFieldLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldLabel.delegate = self
        weatherManger.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        weatherManger.fetchWeather(latitude: lat, longitude: lon)
        
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        textFieldLabel.endEditing(true)
        print(textFieldLabel.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldLabel.endEditing(true)
        print(textFieldLabel.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text{
            weatherManger.fetchWeather(cityName)
        }
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        } else {
            textField.placeholder = "Please enter a city name"
            return false
        }
    }
}

// MARK: - WeatherMangerDelegate

extension WeatherViewController: WeatherMangerDelegate {
    
    func didUpdateWeatherManager(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.sync {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.weatherCondion)
            cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            lat = Float(location.coordinate.latitude)
            lon = Float(location.coordinate.longitude)
            weatherManger.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("Error is: \(error)")
    }
}

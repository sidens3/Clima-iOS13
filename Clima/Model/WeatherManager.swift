//
//  WeatherManager.swift
//  Clima
//
//  Created by Михаил Зиновьев on 02.02.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError( error: Error)
}

struct WeatherManager {
    let apiId = "b92c2490dcb6f1f0699c01375bc60d5b"
    let units = "metric"
    let weatherUrll =
        "https://api.openweathermap.org/data/2.5/weather?appid=b92c2490dcb6f1f0699c01375bc60d5b&units=metric"
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String ) {
        let urlString = "\(weatherUrl)?appid=\(apiId)&units=\(units)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiId)&units=\(units)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)  {
        //1. Create a URl
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("request perform error detected")
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            print("")
            print(String(decoding: weatherData, as: UTF8.self))
            print("")
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            print("parse error detected")
            return nil
        }
    }
}

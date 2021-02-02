//
//  WeatherManager.swift
//  Clima
//
//  Created by Михаил Зиновьев on 02.02.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherUrl =
    "https://api.openweathermap.org/data/2.5/weather?appid=b92c2490dcb6f1f0699c01375bc60d5b&units=metric"
    
    func fetchWeather(cityName: String ) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String)  {
        //1. Create a URl
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session task
            
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            //4. Start the task
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
    }
}


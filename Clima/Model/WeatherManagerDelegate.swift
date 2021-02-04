//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Михаил Зиновьев on 04.02.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {

    func didUpdateWeather(weather: WeatherModel)
}

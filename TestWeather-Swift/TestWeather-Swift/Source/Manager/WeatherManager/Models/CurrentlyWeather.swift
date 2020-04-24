//
//  CurrentlyWeather.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import Foundation

//The properties are optional following the documentation: https://darksky.net/dev/docs#data-point

struct CurrentlyWeather: Decodable {
    let time: Double
    let summary: String?
    let icon: String?
    let precipIntensity: Double?
    let precipProbability: Double?
    let temperature: Double?
    let apparentTemperature: Double?
    let dewPoint: Double?
    let humidity: Double?
    let pressure: Double?
    let windSpeed: Double?
    let windGust: Double?
    let windBearing: Double?
    let cloudCover: Double?
    let uvIndex: Double?
    let visibility: Double?
    let ozone: Double?
}

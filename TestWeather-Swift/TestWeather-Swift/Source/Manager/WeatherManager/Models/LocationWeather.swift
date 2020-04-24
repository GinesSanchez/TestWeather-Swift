//
//  LocationWeather.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import Foundation

//The properties are optional following the documentation: https://darksky.net/dev/docs#data-point

struct LocationWeather: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    var currently: CurrentlyWeather?
}

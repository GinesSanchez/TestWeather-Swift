//
//  WeatherRequest.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import Foundation
import CoreLocation

enum WeatherRequest: APIRequest {
    case currentLocation(location: CLLocation)

    var schema: String {
        return "https://"
    }

    var apiHost: String {
        return "api.darksky.net/"
    }

    var path: String {
        switch self {
        case .currentLocation(let location):
            return "forecast/2bb07c3bece89caf533ac9a5d23d8417/\(location.coordinate.latitude),\(location.coordinate.longitude)"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var queryParameters: [String : String]? {
        switch self {
        case .currentLocation:
            return ["units": "si"]
        }
    }
}

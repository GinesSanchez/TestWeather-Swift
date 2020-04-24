//
//  WeatherManager.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import Foundation
import CoreLocation

enum WeatherManagerError: Error {
    case wrongUrlRequest
    case responseError
    case noResponseData
    case invalidResponse
    case invalidJson
    case invalidResponseCode
}

protocol WeatherManagerType {
    var networkManager: NetworkManagerType { get }
    init(networkManager: NetworkManagerType)
    func getWeather(location: CLLocation, completion: @escaping (Result<LocationWeather, WeatherManagerError>) -> Void)
}

final class WeatherManager: WeatherManagerType {
    var networkManager: NetworkManagerType

    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
        return
    }

    func getWeather(location: CLLocation, completion: @escaping (Result<LocationWeather, WeatherManagerError>) -> Void) {
        guard let urlRequest = WeatherRequest.currentLocation(location: location).urlRequest else {
            return completion(.failure(.wrongUrlRequest))
        }
        networkManager.execute(urlRequest: urlRequest) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(.responseError))
            }

            guard let data = data else {
                return completion(.failure(.noResponseData))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    let locationWeather = try JSONDecoder().decode(LocationWeather.self, from: data)
                    completion(.success(locationWeather))
                } catch {
                    return completion(.failure(.invalidJson))
                }
                break
            default:
                return completion(.failure(.invalidResponseCode))
            }
        }
    }

}

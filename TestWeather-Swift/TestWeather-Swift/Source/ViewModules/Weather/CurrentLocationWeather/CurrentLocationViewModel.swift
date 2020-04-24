//
//  CurrentLocationViewModel.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import Foundation
import CoreLocation

enum ViewModelState {
    case initialized
    case loading
    case ready(currentWeather: CurrentWeatherUI)        //TODO: Do it generic
    case error
    case empty
}

protocol CurrentLocationViewModelType {

    var weatherManager: WeatherManagerType { get }

    init(weatherManager: WeatherManagerType)
}

final class CurrentLocationViewModel: CurrentLocationViewModelType, CurrentLocationViewControllerDelegate {

    var weatherManager: WeatherManagerType

    var state: ViewModelState {
        didSet {
            DispatchQueue.global().sync {
                performAcion()
            }
        }
    }

    init(weatherManager: WeatherManagerType) {
        self.weatherManager = weatherManager
        self.state = .initialized
        return
    }


    //MARK:- CurrentLocationViewControllerDelegate
    func viewDidLoad() {
        self.state = .loading
    }

    //MARK:- State Machine
    func performAcion() {
        switch self.state {
        case .initialized:
            break
        case .loading:
            let location = CLLocation(latitude: 59.337239, longitude: 18.062381)
            self.weatherManager.getWeather(location: location) { (result) in
                switch result {
                case .failure:
                    self.state = .error
                case .success(let locationWeather):
                    guard let currentWeather = locationWeather.currently else {
                        return self.state = .empty
                    }

                    let summary = currentWeather.summary ?? "N/A"
                    let temperature = currentWeather.temperature != nil ? "\(String(currentWeather.temperature!)) Cº" : "N/A"
                    let humidity = currentWeather.humidity != nil ? "\(currentWeather.humidity! * 100) %" : "N/A"
                    let timeDate = Date(timeIntervalSince1970: currentWeather.time)

                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MMM-yyyy"
                    let time = formatter.string(from: timeDate)

                    self.state = .ready(currentWeather: CurrentWeatherUI.init(summary: summary, temperature: temperature, humidity: humidity, time: time))
                    break
                }
            }
            break
        case .empty:
            break
        case .error:
            break;
        case .ready:
            break
        }

        NotificationCenter.default.post(name: Notification.Name("didUpdateViewModelState"), object: self.state)
    }
}

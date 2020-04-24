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
    case gettingLocation
    case loading
    case ready(currentWeather: CurrentWeatherUI)        //TODO: Do it generic
    case error
    case empty
}

protocol CurrentLocationViewModelType {

    var weatherManager: WeatherManagerType { get }

    init(weatherManager: WeatherManagerType)
}

final class CurrentLocationViewModel: NSObject, CurrentLocationViewModelType, CurrentLocationViewControllerDelegate {

    var weatherManager: WeatherManagerType
    let locationManager: CLLocationManager          //TODO: Move to a manager
    var location: CLLocation?

    var state: ViewModelState {
        didSet {
            DispatchQueue.global().sync {
                performAcion()
            }
        }
    }

    init(weatherManager: WeatherManagerType) {
        self.locationManager = CLLocationManager()
        self.weatherManager = weatherManager
        self.state = .initialized
        return
    }


    //MARK:- CurrentLocationViewControllerDelegate
    func viewDidLoad() {
        setUpLocationManager()
        self.state = .gettingLocation
    }

    //MARK:- State Machine
    func performAcion(location: CLLocation? = nil) {
        switch self.state {
        case .initialized:
            break
        case .gettingLocation:
            break
        case .loading:
            guard let location = self.location else {
                self.state = .error
                return
            }
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

private extension CurrentLocationViewModel {
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}

extension CurrentLocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            self.state = .loading
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.state = .error
    }
}

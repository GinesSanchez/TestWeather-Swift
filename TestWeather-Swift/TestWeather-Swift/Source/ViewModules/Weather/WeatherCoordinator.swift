//
//  WeatherCoordinator.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import UIKit

protocol WeatherCoordinatorType: Coordinating { }


final class WeatherCoordinator: WeatherCoordinatorType {

    var navigationController: UINavigationController
    var currentLocationWeather: CurrentLocationViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        return
    }

    func start() {
        currentLocationWeather = CurrentLocationViewController.init(nibName: "CurrentLocationViewController", bundle: nil)
        self.navigationController .pushViewController(currentLocationWeather!, animated: true)
    }

    func stop() {
        self.navigationController .popViewController(animated: true)
        currentLocationWeather = nil
    }
}

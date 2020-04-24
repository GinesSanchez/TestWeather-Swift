//
//  Coordinating.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import UIKit

protocol Coordinating {

    var navigationController: UINavigationController { get }

    init(navigationController: UINavigationController)
    func start()
    func stop()
}

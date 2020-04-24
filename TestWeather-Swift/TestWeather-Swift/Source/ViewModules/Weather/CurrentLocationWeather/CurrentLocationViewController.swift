//
//  CurrentLocationViewController.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import UIKit

protocol CurrentLocationViewControllerDelegate {
    func viewDidLoad()
}

class CurrentLocationViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var viewModel: CurrentLocationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        self.viewModel?.viewDidLoad()
    }
}

// MARK: - Set Up
private extension CurrentLocationViewController {
    func setUp() {
        self.setUpNavigationBar()
        self.setUpObserver()
    }

    func setUpNavigationBar() {
        self.title = "Current Weather"
    }

    func setUpObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceive),
                                               name: Notification.Name("didUpdateViewModelState"),
                                               object: nil)
    }
}

// MARK: - Nofications
private extension CurrentLocationViewController {
    @objc func didReceive(notification: NSNotification) {
        guard let state = notification.object as? ViewModelState else {
            return
        }

        DispatchQueue.main.async {
            switch state {
            case .initialized:
                self.temperatureLabel.text = nil
                self.summaryLabel.text = nil
                self.humidityLabel.text = nil
                self.timeLabel.text = nil
            case .loading:
                self.temperatureLabel.text = "Loading..."
                self.summaryLabel.text = nil
                self.humidityLabel.text = nil
                self.timeLabel.text = nil
            case .empty:
                self.temperatureLabel.text = "No data to show."
                self.summaryLabel.text = nil
                self.humidityLabel.text = nil
                self.timeLabel.text = nil
            case .error:
                self.temperatureLabel.text = "An Error ocurred."
                self.summaryLabel.text = nil
                self.humidityLabel.text = nil
                self.timeLabel.text = nil
            case .ready(let currentWeather):
                self.temperatureLabel.text = "Temperature: \(currentWeather.temperature)"
                self.summaryLabel.text = "Summary: \(currentWeather.summary)"
                self.humidityLabel.text = "Humidity: \(currentWeather.humidity)"
                self.timeLabel.text = "Current Time: \(currentWeather.time)"
            }
        }
    }
}

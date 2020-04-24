//
//  NetworkManager.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import UIKit

protocol NetworkManagerType {
    func createUrlRequestWith(schema: String, host: String, path: String, parameters: Dictionary<String, String>) -> URLRequest?
    func execute(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

final class NetworkManager: NetworkManagerType {
    func createUrlRequestWith(schema: String, host: String, path: String, parameters: Dictionary<String, String>) -> URLRequest? {
        var components = URLComponents.init()
        components.scheme = schema
        components.host = host
        components.path = path

        if parameters.count > 0 {
            var parametersArray: Array<URLQueryItem> = Array()
            parameters.forEach { (key: String, value: String) in
                parametersArray.append(URLQueryItem.init(name: key, value: value))
            }
        }

        guard let url = components.url else { return nil }

        return URLRequest.init(url: url)
    }

    func execute(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: urlRequest, completionHandler: completion).resume()
    }
}

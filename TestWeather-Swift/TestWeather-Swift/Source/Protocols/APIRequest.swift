//
//  APIRequest.swift
//  TestWeather-Swift
//
//  Created by Gines Sanchez Merono on 2020-04-24.
//  Copyright © 2020 Ginés Sanchez. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

protocol APIRequest {
    var schema: String { get }
    var apiHost: String { get }
    var path: String { get }
    var method: HTTPMethod { get }

    //Optional
    var queryParameters: [String: String]? { get }

    var urlRequest: URLRequest? {get}
}

extension APIRequest {
    var urlRequest: URLRequest? {
        let urlPath = apiHost + path
        guard var urlComponents = URLComponents(string: urlPath) else {return nil}
        urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0, value: $1) }

        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue.capitalized

            return request
        }
        return nil
    }
}

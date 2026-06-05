//
//  ApiBuilder.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

protocol ApiBuilder {
    var baseProtocol: String { get }
    var path: String { get }
    var baseURL: String { get }
    var port: Int? { get }
    var httpMethod: HttpMethod { get }
    var globalHeaders: [String: String] { get }
    var additionalHeaders: [String: String] { get }
    var parameters: [String: Any] { get }
    var urlParameters: [String: String] { get }
    var urlRequest: URLRequest? { get }
}

extension ApiBuilder {
    var urlRequest: URLRequest? {
        var components = URLComponents()
        components.scheme = baseProtocol
        components.host = baseURL
        components.port = port
        components.path = path

        let extraQueryItems = urlParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        if !extraQueryItems.isEmpty {
            components.queryItems = extraQueryItems
        }

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        for (key, value) in globalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        for (key, value) in additionalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if httpMethod != .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        return request
    }
}
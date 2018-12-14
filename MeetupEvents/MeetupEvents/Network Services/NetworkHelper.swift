//
//  NetworkHelper.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

final class NetworkHelper {
  static func performDataTask(urlString: String, httpMethod: String, completionHandler: @escaping (APIError?, Data?) ->Void) {
    guard let url = URL(string: urlString) else {
      completionHandler(APIError.badURL("badURL: \(urlString)"), nil)
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completionHandler(APIError.networkError(error), nil)
      }
      if let response = response as? HTTPURLResponse {
        print("response status code is \(response.statusCode)")
        guard response.statusCode >= 200 && response.statusCode < 300 else {
          if let data = data {
            completionHandler(APIError.badStatusCode(response.statusCode), data)
          } else {
            completionHandler(APIError.badStatusCode(response.statusCode), nil)
          }
          return
        }
        completionHandler(nil, nil)
      }
      if let data = data {
        completionHandler(nil, data)
      }
    }.resume()
  }
}

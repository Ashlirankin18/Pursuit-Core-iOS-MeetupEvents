//
//  ImageHelper.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/13/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

final class ImageHelper {
  static let shared = ImageHelper()
  private let cache: NSCache<NSString, UIImage>?
  private let sharedCache = NSCache<NSString, UIImage>()
  
  private init() {
    cache = NSCache()
  }
  
  static func fetchImage(with urlString: String, completionHandler: @escaping (APIError?, UIImage?) -> Void) {
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data) in
      if let error = error {
        completionHandler(APIError.networkError(error), nil)
      } else if let data = data {
          let image = UIImage(data: data)
          DispatchQueue.main.async {
            completionHandler(nil, image)
          }
      }
    }
  }
  
  public func cachedImage(url: String) -> UIImage? {
    return sharedCache.object(forKey: url as NSString)
  }
  
  public func setImage(key: String, image: UIImage) {
    sharedCache.setObject(image, forKey: key as NSString)
  }
}


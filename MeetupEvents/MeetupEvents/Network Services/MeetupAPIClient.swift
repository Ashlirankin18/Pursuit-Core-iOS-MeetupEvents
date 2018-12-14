//
//  MeetupAPIClient.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

final class MeetupAPIClient {
  
  // search events from your groups
  static func searchEvents(keyword: String, completionHandler: @escaping (APIError?, [Event]?) -> Void) {
    let urlString = "https://api.meetup.com/find/events?key=\(SecretKeys.APIKey)&fields=group_photo&text=\(keyword)&lat=40.72&lon=-73.84"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data) in
      if let error = error {
        completionHandler(error, nil)
      } else if let data = data {
        do {
          let events = try JSONDecoder().decode([Event].self, from: data)
          completionHandler(nil, events)
        } catch {
          completionHandler(APIError.decodingError(error), nil)
        }
      }
    }
  }
  
  // events you have RSVP'd to , valid values are "yes" or "no"
  static func memberEvents(completionHandler: @escaping (APIError?, [Event]?) -> Void) {
    let urlString = "https://api.meetup.com/self/events?key=\(SecretKeys.APIKey)&page=10&status=upcoming&desc=false&rsvp=yes"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data) in
      if let error = error {
        completionHandler(error, nil)
      } else if let data = data {
        do {
          let events = try JSONDecoder().decode([Event].self, from: data)
          completionHandler(nil, events)
        } catch {
          completionHandler(APIError.decodingError(error), nil)
        }
      }
    }
  }
  
  static func updateRSVP(eventId: String, rsvpStatus: String, completionHandler: @escaping (APIError?, RSVP?, BadRequest?) -> Void) {
    let urlString = "https://api.meetup.com/2/rsvp?key=\(SecretKeys.APIKey)&event_id=\(eventId)&rsvp=\(rsvpStatus)"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "POST") { (error, data) in
      if let error = error {
        if let data = data {
          do {
            let badRequest = try JSONDecoder().decode(BadRequest.self, from: data)
            completionHandler(error, nil, badRequest)
          } catch {
            completionHandler(APIError.decodingError(error), nil, nil)
          }
        } else {
          completionHandler(error, nil, nil)
        }
      } else if let data = data {
        do {
          let rsvp = try JSONDecoder().decode(RSVP.self, from: data)
          completionHandler(nil, rsvp, nil)
        } catch {
          completionHandler(APIError.decodingError(error), nil, nil)
        }
      }
    }
  }
  
  
}

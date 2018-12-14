//
//  Event.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

struct Event: Codable {
  let created: TimeInterval?
  let duration: TimeInterval?
  let id: String
  let name: String
  let status: String?
  let time: TimeInterval
  let local_date: String
  let local_time: String
  let updated: TimeInterval?
  let waitlist_count: Int
  let yes_rsvp_count: Int
  struct Venue: Codable {
    let id: Int
    let name: String
    let lat: Double
    let lon: Double
    let repinned: Bool
    let address_1: String
    let city: String
    let country: String
    let localized_country_name: String
    let zip: String?
    let state: String?
  }
  let venue: Venue?
  struct Group: Codable {
    let created: TimeInterval
    let name: String
    let id: Int
    let join_mode: String
    let lat: Double
    let lon: Double
    let urlname: String
    let who: String
    let localized_location: String
    let state: String
    let country: String
    let region: String
    let timezone: String
    struct Photo: Codable {
      let id: Int
      let highresLink: URL
      let photoLink: URL
      let thumbLink: URL
      let type: String
      let baseURL: URL
      private enum CodingKeys: String, CodingKey {
        case id
        case highresLink = "highres_link"
        case photoLink = "photo_link"
        case thumbLink = "thumb_link"
        case type
        case baseURL = "base_url"
      }
    }
    let photo: Photo?
  }
  let group: Group
  let link: URL
  let description: String?
  let visibility: String
}


extension String {
  func stripHTML() -> String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
}

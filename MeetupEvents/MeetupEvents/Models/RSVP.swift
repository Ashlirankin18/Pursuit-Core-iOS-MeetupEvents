//
//  RSVP.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/13/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

struct RSVP: Codable {
  struct Venue: Codable {
    let country: String
    let city: String
    let name: String
    let id: Int
  }
  let venue: Venue
  let created: TimeInterval
  let response: String // "yes" or "no"
  let rsvpId: Int
  private enum CodingKeys: String, CodingKey {
    case venue
    case created
    case response
    case rsvpId = "rsvp_id"
  }
}

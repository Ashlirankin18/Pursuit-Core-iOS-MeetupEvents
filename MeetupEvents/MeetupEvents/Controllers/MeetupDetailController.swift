//
//  MeetupDetailController.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/13/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class MeetupDetailController: UIViewController {
  
  @IBOutlet weak var rsvpStatusLabel: UILabel!
  
  private var rsvpStatus = "no"
  public var event: Event! 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = event.name
    fetchMemberEvents()
  }
  
  private func fetchMemberEvents() {
    MeetupAPIClient.memberEvents { (apiError, events) in
      if let apiError = apiError {
        print(apiError.getErrorMessage())
      } else if let events = events {
        let results = events.filter { $0.id == self.event.id }
        DispatchQueue.main.async {
          if let _ = results.first {
            self.rsvpStatusLabel.text = "Going"
            self.rsvpStatus = "yes"
          } else {
            self.rsvpStatusLabel.text = "Not Going"
            self.rsvpStatus = "no"
          }
        }
      }
    }
  }
  
  @IBAction func udpateRSVP(_ sender: UIButton) {
    rsvpStatus = rsvpStatus == "no" ? "yes" : "no"
    MeetupAPIClient.updateRSVP(eventId: event.id, rsvpStatus: rsvpStatus) { (apiError, rsvp, badRequest) in
      if let badRequest = badRequest {
        DispatchQueue.main.async {
          self.rsvpStatusLabel.text = badRequest.details
        }
      }
      else if let apiError = apiError {
        print(apiError.getErrorMessage())
      } else if let rsvp = rsvp {
        DispatchQueue.main.async {
          self.rsvpStatusLabel.text = rsvp.response == "yes" ? "Going" : "Not Going"
        }
      }
    }
  }
}

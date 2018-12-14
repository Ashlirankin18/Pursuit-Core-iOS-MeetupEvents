//
//  EventCell.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/13/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
  @IBOutlet weak var eventImage: UIImageView!
  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var eventDescription: UILabel!
  
  public func configureCell(event: Event) {
    eventName.text = event.name
    eventDescription.text = event.description?.stripHTML()
    eventImage.image = UIImage(named: "placeholderImage")
    if let url = event.group.photo?.photoLink {
      // retrieve cache image if available
      if let image = ImageHelper.shared.cachedImage(url: url.absoluteString) {
        self.eventImage.image = image
      } else {
        ImageHelper.fetchImage(with: url.absoluteString) { (apiError, image) in
          if let apiError = apiError {
            print(apiError.getErrorMessage())
          } else if let image = image {
            self.eventImage.image = image
            // set cache
            ImageHelper.shared.setImage(key: url.absoluteString, image: image)
          }
        }
      }
    }
  }
}

//
//  ViewController.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class MeetupEventsController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  private var events = [Event]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    fetchEvents(keyword: "ios")
  }
  
  private func fetchEvents(keyword: String) {
    MeetupAPIClient.searchEvents(keyword: keyword) { (apiError, events) in
      if let apiError = apiError {
        print(apiError.getErrorMessage())
      } else if let events = events {
        self.events = events
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let indexPath = tableView.indexPathForSelectedRow,
      let meetupDetailController = segue.destination as? MeetupDetailController else { return }
    let event = events[indexPath.row]
    meetupDetailController.event = event
  }
}

extension MeetupEventsController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else {
      fatalError("event cell is nil")
    }
    let event = events[indexPath.row]
    cell.configureCell(event: event)
    return cell
  }
}

extension MeetupEventsController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}

extension MeetupEventsController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let searchText = searchBar.text,
      let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
      !searchText.isEmpty
    else { return }
    fetchEvents(keyword: searchTextEncoded)
  }
}


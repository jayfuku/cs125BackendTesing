//
//  CalendarEvent.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation

struct CalendarEvent : Codable {
    var time: Date
    var name: String
    var desc: String
}

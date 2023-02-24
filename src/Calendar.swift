//
//  Calendar.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation

class UserCalendar {
    //Class representation for calendar
    //Should be singleton
    
    // Year -> Month -> Day -> [CalendarEvent]
    private var calendar: Dictionary<Int, Dictionary<Int, Dictionary<Int, [CalendarEvent]>>>

    static var initialized: Bool = false
    
    init(){
        assert(!UserCalendar.initialized, "ERROR: UserCalendar has already been created")
        self.calendar = Dictionary<Int, Dictionary<Int, Dictionary<Int, [CalendarEvent]>>>()
    }
    
    public func addEvent(_ date: Date, _ name: String, _ desc: String){
        //Add an event to the calendar given a date name and description
        //TODO: What should happen if the event already exists on that day and time?
        let event = CalendarEvent(date, name, desc)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .day, .month], from: date)
        let year_: Int = components.year!
        let month_: Int = components.month!
        let day_: Int = components.day!
        
        if (self.calendar[year_] == nil){
            self.calendar[year_] = Dictionary<Int, Dictionary<Int, [CalendarEvent]>>()
        }
        if (self.calendar[year_]![month_] == nil) {
            self.calendar[year_]![month_] = Dictionary<Int, [CalendarEvent]>()
        }
        if (self.calendar[year_]![month_]![day_] == nil){
            self.calendar[year_]![month_]![day_] = []
        }
        
        self.calendar[year_]![month_]![day_]!.append(event)
    }
    
    public func getEventByDay(_ date: Date) -> [CalendarEvent]{
        // Get all events in a day
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .day, .month], from: date)
        let year_: Int? = components.year
        let month_: Int? = components.month
        let day_: Int? = components.day
        
        return self.calendar[year_!]![month_!]![day_!]!
    }
    
    // TODO: Do we need more detailed ways to get events?
}

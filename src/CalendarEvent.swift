//
//  CalendarEvent.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation

class CalendarEvent {
    
    private var time: Date
    private var name: String
    private var desc: String
    //More can be added
    
    init(_ time: Date, _ name: String, _ desc: String){
        self.time = time
        self.name = name
        self.desc = desc
    }
    
    public func getTime() -> Date{
        return self.time
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getDesc() -> String{
        return self.name
    }
    
}

//
//  UserSleepDatabase.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation

struct SleepData {
    var Time: Int
    var slept: Date
    var woke: Date
}

class UserSleepDatabase{
    //This class is what gets stored in local storage
    //We want this to be singleton
    
    private var sleepDatabase: Dictionary<Int, Dictionary<Int, Dictionary<Int, SleepData>>> //[Int: [Int: [Int:SleepData]]] //Year -> Month -> Day -> Data
    static public var initialized: Bool = false;
    
    init(){
        assert(!UserSleepDatabase.initialized, "ERROR: UserSleepDatabase has already been created once")
        self.sleepDatabase = Dictionary<Int, Dictionary<Int, Dictionary<Int, SleepData>>>()
        UserSleepDatabase.initialized = true
    }
    
    public func getData(date: Date) -> SleepData{
        //Getter for data
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .day, .month], from: date)
        let year_: Int? = components.year
        let month_: Int? = components.month
        let day_: Int? = components.day
        
        return self.sleepDatabase[year_!]![month_!]![day_!]!
    }
    
    public func addData(date: Date, data: SleepData) -> Void{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from : date)
        let year_ : Int? = components.year
        let month_: Int? = components.month
        let day_: Int? = components.day
        
        self.sleepDatabase[year_!]![month_!]![day_!] = data
    }
}

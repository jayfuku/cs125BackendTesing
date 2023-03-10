//
//  UserSleepDatabase.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation

struct SleepData : Codable{
    var Time: Double
    var slept: Date
    var woke: Date
}

typealias sleepStorage = Dictionary<Int, Dictionary<Int, Dictionary<Int, SleepData>>>

class UserSleepDatabase : Codable{
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
        let year_: Int = components.year!
        let month_: Int = components.month!
        let day_: Int = components.day!
        
        return self.sleepDatabase[year_]![month_]![day_]!
    }
    
    public func addData(date: Date, data: SleepData) -> Void{
        //TODO: What should happen if a day already has data for any reason?
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from : date)
        let year_ : Int = components.year!
        let month_: Int = components.month!
        let day_: Int = components.day!
        
        if (self.sleepDatabase[year_] == nil){
            self.sleepDatabase[year_] = Dictionary<Int, Dictionary<Int, SleepData>>()
        }
        if (self.sleepDatabase[year_]![month_] == nil){
            self.sleepDatabase[year_]![month_] = Dictionary<Int, SleepData>()
        }
        
        self.sleepDatabase[year_]![month_]![day_] = data
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.sleepDatabase)
    }
    
    public required init(from decoder: Decoder) throws {
        //When data already exists in localstorage
        let container = try decoder.singleValueContainer()
        self.sleepDatabase = try container.decode(Dictionary.self)
    }
}

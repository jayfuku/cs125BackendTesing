//
//  PersonalModel.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation

struct sleepAmnts {
    //Struct that contains the total sleep amounts from the past week, month, and year
    var week: [Int]
    var month: [Int]
    var year: [Int]
}

struct sleepTimes {
    //Struct that contains sleep times from the apst week, month, and year
    var week: [Int]
    var month: [Int]
    var year: [Int]
}

class PersonalModel {
    //Personal Model for user
    //Should be singleton
    
    private var totSleepAmnts: sleepAmnts
    private var totSleepTimes: sleepTimes
    private var dayInit: Date //When was this personal model created
    private var consistentSleep: Bool
    private var goodSleepAmnt: Bool
    
    static var initialized: Bool = false
    
    init(){
        assert(!PersonalModel.initialized, "ERROR: Personal model is already intialized")
        self.totSleepAmnts = sleepAmnts(week: [], month: [], year: [])
        self.totSleepTimes = sleepTimes(week: [], month: [], year: [])
        self.dayInit = Date.now
        self.consistentSleep = false
        self.goodSleepAmnt = false
    }
    
    public func updateAll(data: SleepData) -> Void{
        //This function is called everyday when the user wakes up
        //Takes in the most recent SleepData and uses it to update members
        
        self.updateSleepTotals(data)
        self.updateConsistentSleep()
        self.updateGoodSleepAmnt()
    }
    
    public func getConsistentSleep() -> Bool{
        return self.consistentSleep
    }
    
    public func getGoodSleepAmnt() -> Bool{
        return self.goodSleepAmnt
    }
    
    private func getAverage(_ totals: [Int]) -> Float{
        //Helper function to get the average sleep of an array
        // Ex: getAverageSleepTime(self.totSleepTimes.week) to get average of week
        var count = 0
        var total = 0
        for time in totals{
            count += 1
            total += time
        }
        return Float(total)/Float(count)
    }
    
    private func updateSleepTotals(_ data: SleepData) -> Void{
        //Pop before adding if array is already full
        if (self.totSleepTimes.week.count == 7) {
            self.totSleepTimes.week.removeFirst(1)
        }
        self.totSleepTimes.week.append(data.Time)
        
        if (self.totSleepTimes.month.count == 31){
            self.totSleepTimes.month.removeFirst(1)
        }
        self.totSleepTimes.month.append(data.Time)
        
        if (self.totSleepTimes.year.count == 365){
            self.totSleepTimes.year.removeFirst(1)
        }
        self.totSleepTimes.year.append(data.Time)
    }
    
    private func updateSleepAmnts(_ data: SleepData) -> Void{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: data.woke)
        if (self.totSleepAmnts.week.count == 7) {
            self.totSleepAmnts.week.removeFirst(1)
        }
        self.totSleepAmnts.week.append(hour)
        
        if (self.totSleepAmnts.month.count == 31){
            self.totSleepAmnts.month.removeFirst(1)
        }
        self.totSleepAmnts.month.append(hour)
        
        if (self.totSleepAmnts.year.count == 365){
            self.totSleepAmnts.year.removeFirst(1)
        }
        self.totSleepAmnts.year.append(hour)
    }
    
    private func updateConsistentSleep() -> Void{
        //Use standard deviation to see if user gets consistent sleep over the past week
        let mean = self.getAverage(self.totSleepTimes.week)
        var top = 0.0
        var bottom = 0.0
        var stdDeviation = 0.0
        
        for i in 0..<self.totSleepTimes.week.count {
            top += pow(Double(Float(self.totSleepTimes.week[i]) - mean), 2)
        }
        bottom = top / sqrt(Double(self.totSleepTimes.week.count))
        stdDeviation = sqrt(bottom)
        
        if (stdDeviation < 2){
            self.consistentSleep = true
        }
        else {
            self.consistentSleep = false
        }
    }
    
    private func updateGoodSleepAmnt() -> Void{
        let avg = self.getAverage(self.totSleepTimes.week)
        if (avg >= 6) {
            self.goodSleepAmnt = true
        }
        else{
            self.goodSleepAmnt = false
        }
    }
    
    //TODO: Recommendation algorithm should interface with personal model or be a part of it
}

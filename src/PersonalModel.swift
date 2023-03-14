//
//  PersonalModel.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation

struct sleepAmnts {
    //Struct that contains the total sleep amounts from the past week, month, and year
    var week: [Double]
    var month: [Double]
    var year: [Double]
}

struct sleepTimes {
    //Struct that contains sleep times from the apst week, month, and year
    var week: [Double]
    var month: [Double]
    var year: [Double]
}

class PersonalModel {
    //Personal Model for user
    //Should be singleton
    
    private var totSleepAmnts: sleepAmnts
    private var SleepTimes: sleepTimes
    private var dayInit: Date //When was this personal model created
    private var consistentSleep: Bool
    private var sleepStdDev: Double
    private var goodSleepAmnt: Bool
    private var SleepScore: Int
    
    static var initialized: Bool = false
    
    init(){
        assert(!PersonalModel.initialized, "ERROR: Personal model is already intialized")
        self.totSleepAmnts = sleepAmnts(week: [], month: [], year: [])
        self.SleepTimes = sleepTimes(week: [], month: [], year: [])
        self.dayInit = Date.now
        self.consistentSleep = false
        self.goodSleepAmnt = false
        self.SleepScore = 0
        self.sleepStdDev = 0
    }
    
    public func _clearModel(){
        //ONLY FOR TESTING, clear the personal model of all data
        //TODO: Remove in actual app
        self.totSleepAmnts = sleepAmnts(week: [], month: [], year: [])
        self.SleepTimes = sleepTimes(week: [], month: [], year: [])
    }
    
    public func updateAll(data: SleepData) -> Void{
        //This function is called everyday when the user wakes up
        //Takes in the most recent SleepData and uses it to update members
        
        self.updateSleepTotals(data)
        self.updateSleepAmnts(data)
        self.updateConsistentSleep()
        self.updateGoodSleepAmnt()
        self.updateSleepScore()
    }
    
    public func getConsistentSleep() -> Bool{
        return self.consistentSleep
    }
    
    public func getGoodSleepAmnt() -> Bool{
        return self.goodSleepAmnt
    }
    
    private func getAverage(_ totals: [Double]) -> Float{
        //Helper function to get the average sleep of an array
        // Ex: getAverageSleepTime(self.totSleepTimes.week) to get average of week
        var count = 0
        var total = 0.0
        for time in totals{
            count += 1
            total += time
        }
        return Float(total)/Float(count)
    }
    
    private func updateSleepTotals(_ data: SleepData) -> Void{
        //Pop before adding if array is already full
        if (self.SleepTimes.week.count == 7) {
            self.SleepTimes.week.removeFirst(1)
        }
        self.SleepTimes.week.append(data.Time)
        
        if (self.SleepTimes.month.count == 31){
            self.SleepTimes.month.removeFirst(1)
        }
        self.SleepTimes.month.append(data.Time)
        
        if (self.SleepTimes.year.count == 365){
            self.SleepTimes.year.removeFirst(1)
        }
        self.SleepTimes.year.append(data.Time)
    }
    
    private func updateSleepAmnts(_ data: SleepData) -> Void{
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: data.woke))
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
        //TODO: Test standard deviation formula with better, more varied data
        let mean = self.getAverage(self.SleepTimes.week)
        var top = 0.0
        var bottom = self.SleepTimes.week.count
        var stdDeviation = 0.0
        
        for i in 0..<self.SleepTimes.week.count {
            top += pow(Double(Float(self.SleepTimes.week[i]) - mean), 2)
        }
        
        stdDeviation = sqrt(top/Double(bottom))
        
        if (stdDeviation < 1){
            self.consistentSleep = true
        }
        else {
            self.consistentSleep = false
        }
        
        self.sleepStdDev = stdDeviation
    }
    
    private func updateGoodSleepAmnt() -> Void{
        let avg = self.getAverage(self.SleepTimes.week)
        if (6 <= avg && avg <= 11) {
            //CDC study shows more than ~10 hours is an unsafe amount of sleep
            self.goodSleepAmnt = true
        }
        else{
            self.goodSleepAmnt = false
        }
    }
    
    private func updateSleepScore() -> Void {
        var tempSleepScore = 100
        
        //Consistency
        // Deduct sleep score based on std deviation of users past sleep up to max of 40
        // <30 minute std deviation is considered perfect sleep

        var consistencyDeduction = 0.0
        if (self.sleepStdDev > 0.75){
            consistencyDeduction += ((self.sleepStdDev - 0.75) / self.sleepStdDev) * 50
        }
        tempSleepScore -= Int(consistencyDeduction)
        
        
        //Quantity
        // Deduct sleep score based on quantity of most recent sleep up to max of 60
        // Every 10 minutes away from below 7 or above 9 hours of sleep deducts 5 points
        let recentSleep = self.totSleepAmnts.week[self.totSleepAmnts.week.count-1]
        if (recentSleep <= 7){
            tempSleepScore -= min(6000,Int(100.0 * ((7.0-recentSleep) / (10.0/60.0)) * 4.0)) / 100

        }
        else if (recentSleep >= 9) {
            tempSleepScore -= min(6000,Int(100.0 * ((recentSleep - 9.0) / (10.0/60.0)) * 4.0)) / 100

        }
        
        self.SleepScore = tempSleepScore
    }
}

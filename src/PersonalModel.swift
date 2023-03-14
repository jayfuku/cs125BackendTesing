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
    
    private var sleepDates: sleepAmnts
    private var sleepAmounts: sleepTimes
    private var dayInit: Date //When was this personal model created
    private var consistentSleep: Bool
    private var sleepStdDev: Double
    private var goodSleepAmnt: Bool
    private var SleepScore: Double
    
    static var initialized: Bool = false
    
    init(){
        assert(!PersonalModel.initialized, "ERROR: Personal model is already intialized")
        self.sleepDates = sleepAmnts(week: [], month: [], year: [])
        self.sleepAmounts = sleepTimes(week: [], month: [], year: [])
        self.dayInit = Date.now
        self.consistentSleep = false
        self.goodSleepAmnt = false
        self.SleepScore = 0.0
        self.sleepStdDev = 0
    }
    
    public func _clearModel(){
        //ONLY FOR TESTING, clear the personal model of all data
        //TODO: Remove in actual app
        self.sleepDates = sleepAmnts(week: [], month: [], year: [])
        self.sleepAmounts = sleepTimes(week: [], month: [], year: [])
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
        if (self.sleepAmounts.week.count == 7) {
            self.sleepAmounts.week.removeFirst(1)
        }
        self.sleepAmounts.week.append(data.Time)
        
        if (self.sleepAmounts.month.count == 31){
            self.sleepAmounts.month.removeFirst(1)
        }
        self.sleepAmounts.month.append(data.Time)
        
        if (self.sleepAmounts.year.count == 365){
            self.sleepAmounts.year.removeFirst(1)
        }
        self.sleepAmounts.year.append(data.Time)
    }
    
    private func updateSleepAmnts(_ data: SleepData) -> Void{
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: data.woke))
        if (self.sleepDates.week.count == 7) {
            self.sleepDates.week.removeFirst(1)
        }
        self.sleepDates.week.append(hour)
        
        if (self.sleepDates.month.count == 31){
            self.sleepDates.month.removeFirst(1)
        }
        self.sleepDates.month.append(hour)
        
        if (self.sleepDates.year.count == 365){
            self.sleepDates.year.removeFirst(1)
        }
        self.sleepDates.year.append(hour)
    }
    
    private func updateConsistentSleep() -> Void{
        //Use standard deviation to see if user gets consistent sleep over the past week
        //TODO: Test standard deviation formula with better, more varied data
        let mean = self.getAverage(self.sleepDates.week)
        var top = 0.0
        let bottom = self.sleepDates.week.count
        var stdDeviation = 0.0
        
        for i in 0..<self.sleepDates.week.count {
            top += pow(Double(Float(self.sleepDates.week[i]) - mean), 2)
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
        let avg = self.getAverage(self.sleepAmounts.week)
        if (6 <= avg && avg <= 11) {
            //CDC study shows more than ~10 hours is an unsafe amount of sleep
            self.goodSleepAmnt = true
        }
        else{
            self.goodSleepAmnt = false
        }
    }
    
    private func updateSleepScore() -> Void {
        var tempSleepScore = 100.0
        
        //Consistency
        // Deduct sleep score based on std deviation of users past sleep up to max of 40
        // <30 minute std deviation is considered perfect sleep

        var consistencyDeduction = 0.0
        if (self.sleepStdDev > 0.75){
            consistencyDeduction += ((self.sleepStdDev - 0.75) / self.sleepStdDev) * 50
        }
        tempSleepScore -= min(40, consistencyDeduction)
        //Quantity
        // Deduct sleep score based on quantity of most recent sleep up to max of 60
        // Every 10 minutes away from below 7 or above 9 hours of sleep deducts 5 points
        let recentSleep = self.sleepAmounts.week[self.sleepAmounts.week.count-1]
        if (recentSleep <= 7){
            tempSleepScore -= Double(min(6000,Int(100.0 * ((7.0-recentSleep) / (10.0/60.0)) * 4.0)) / 100)

        }
        else if (recentSleep >= 9) {
            tempSleepScore -= Double(min(6000,Int(100.0 * ((recentSleep - 9.0) / (10.0/60.0)) * 4.0)) / 100)

        }
        
        self.SleepScore = tempSleepScore
    }
    
    public func getSleepArrays() -> (sleepAmnts, sleepTimes){
        return (self.sleepDates, self.sleepAmounts)
    }
    
    public func getSleepScore() -> Double {
        return self.SleepScore
    }
}

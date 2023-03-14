//
//  RecommendationAlgorithm.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 3/13/23.
//

import Foundation

enum recommendations {
    case moreSleep
    case lessSleep
    case earlierSleeptime
    case laterSleepTime
    // case earlierWakeTime NOTE: impossible to discern wake time with structure of personal model
    case maintainRhythm
    // case takeANap
}

struct recommendationData {
    var incDecSleep : Double? // How much the user should sleep more or less
    var newSleepTime : Double? // When the user should sleep or wake up at
    var rhythm : Bool? // Should the user keep a rhythm or not? TODO: what should this be represented as
}

class RecommendationAlgorithm {
    private var model : PersonalModel
    
    init (_ model : PersonalModel){
        self.model = model
    }
    
    public func recommend() -> [(recommendations, recommendationData, Double)]{
        // Return a ranked list of recommendations to make to the user
        // Try each recommendation and rank them based on their potential sleep score
        
        //TODO: Do something with the original sleep score
        var recs : [(recommendations, recommendationData, Double)] = []
        
        let (sleepAmnts, sleepTimes) = self.model.getSleepArrays()
        let (amntsLen, timesLen) = (sleepAmnts.week.count, sleepTimes.week.count)
        
        for i in stride(from: 0.5, to: 3.1, by:0.5){
            // Increase or decrease sleep times in half hour increments up to 3 hours
            var tempSleepAmnts = sleepAmnts.week
            tempSleepAmnts.removeFirst(1)
            tempSleepAmnts.append(sleepAmnts.week[amntsLen-1]+i)
            var tempSleepScore = self.simulateSleepScore(tempSleepAmnts, sleepTimes.week)
            recs.append((recommendations.moreSleep, recommendationData(incDecSleep: i), tempSleepScore))
            
            tempSleepAmnts = sleepAmnts.week
            tempSleepAmnts.removeFirst(1)
            tempSleepAmnts.append(sleepAmnts.week[amntsLen-1]-i)

            tempSleepScore = self.simulateSleepScore(tempSleepAmnts, sleepTimes.week)
            recs.append((recommendations.lessSleep, recommendationData(incDecSleep: -i), tempSleepScore))
            
            var tempSleepTimes = sleepTimes.week
            tempSleepTimes.removeFirst(1)
            tempSleepTimes.append(sleepTimes.week[timesLen-1] - i)
            tempSleepScore = self.simulateSleepScore(sleepAmnts.week, tempSleepTimes)
            recs.append((recommendations.earlierSleeptime, recommendationData(newSleepTime: tempSleepTimes[timesLen-1]), tempSleepScore))
            
            tempSleepTimes = sleepTimes.week
            tempSleepTimes.removeFirst(1)
            tempSleepTimes.append(sleepTimes.week[timesLen-1]-i)
            tempSleepScore = self.simulateSleepScore(sleepAmnts.week, tempSleepTimes)
            recs.append((recommendations.laterSleepTime, recommendationData(newSleepTime: tempSleepTimes[timesLen-1]), tempSleepScore))
        }
        
        
        
        return recs.sorted(by: {$0.2 > $1.2})
    }
    
    private func simulateSleepScore(_ sleepAmnts : [Double], _ sleepTimes:[Double]) -> Double{
        //Given sleepAmnts and sleepTimes arrays, simulate the potential sleep score
        var tempSleepScore = 100.0
        var consistencyDeduction = 0.0
        var stdDev = self.stdDevHelper(sleepAmnts)
        if (stdDev > 0.75){
            consistencyDeduction += ((stdDev - 0.75) / stdDev) * 50
        }
        tempSleepScore -= consistencyDeduction
        
        let recentSleep = sleepTimes[sleepTimes.count-1]
        if (recentSleep <= 7){
            tempSleepScore -= Double(min(6000,Int(100.0 * ((7.0-recentSleep) / (10.0/60.0)) * 4.0)) / 100)

        }
        else if (recentSleep >= 9) {
            tempSleepScore -= Double(min(6000,Int(100.0 * ((recentSleep - 9.0) / (10.0/60.0)) * 4.0)) / 100)
        }
        
        return tempSleepScore
    }
    
    private func stdDevHelper(_ sleepTimes: [Double]) -> Double{
        //Helper function to calcuate standard deviation
        let mean = Double(sleepTimes.reduce(0, +)) / Double(sleepTimes.count)
        var top = 0.0
        let bottom = sleepTimes.count
        
        for i in 0..<sleepTimes.count {
            top += pow(Double(sleepTimes[i]) - mean, 2)
        }
        
        return sqrt(top/Double(bottom))
    }
        
}

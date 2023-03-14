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
    case earlierWakeTime
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
    
    public func recommend() -> [(recommendations, recommendationData)]{
        // Return a ranked list of recommendations to make to the user
        // Try each recommendation and rank them based on their potential sleep score
        
        return [(recommendations.moreSleep, recommendationData(incDecSleep: 4.0))]
    }
}

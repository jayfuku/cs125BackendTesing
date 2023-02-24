//
//  UserSleepDataRetriever.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import Foundation
import HealthKit

class UserSleepDataRetriever {
    //An instance of this gets created every day
    
    private var currentDay: Date;
    private var HKStore: HKHealthStore //Needs to be changed of HKHealthstore type once in actual app
    
    init(HKStore: HKHealthStore){
        //HKHealthStore object should already be authorized before being placed in this class
        self.currentDay = Date.now;
        self.HKStore = HKStore;
    }
    
    private func checkPermissions() -> Bool{
        //Use HKStore item to check if we have permission to retrie data yet
        // return self.HKStore.authorizationStatus(?????)
        return true
    }
    
    private func createQuery() {
        //return type: HKSampleQuery
        //Create query to get sleep data of most recent sleep
    }
    
    public func retrieveData() -> SleepData{
        //Get data from Apple health data
        assert(self.checkPermissions(), "App does not have permission to access health data")
        
        // Create query based on current day
        //var query = self.createQuery()
        
        // Use query to retrieve the users most recent sleep
        // Should retrieve whole night of sleep
        
        
        //Return a Sleepdata for the current day
        return SleepData(Time: 1, slept: Date.now, woke: Date.now) //PLACEHOLDER
    }
    
    
}

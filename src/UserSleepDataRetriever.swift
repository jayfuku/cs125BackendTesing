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
    
    private var HKStore: HKHealthStore //Needs to be changed of HKHealthstore type once in actual app
    
    init(){
        self.HKStore = HKHealthStore()
        self.requestAuth()
    }
    
    private func requestAuth() -> Void{
        //TODO: Need to figure out how to forgo sharing settings since our app doesnt write any health data to HealthkitAPI
        let typesToShare = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        ])
        let typesToRead = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        ])
        
        self.HKStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
                if !success{
                    print("Authorization failed")
                }
                else if success{
                    print("Authorization succeeded")
                }
        }
        print("Finish getting permissions")
    }
    
    private func executeQuery(_ number: Int = 20) -> SleepData {
        //Create query to get sleep data of most recent sleep
        // Params:
        //      number: Amount of data to retrieve, default 20
        var retSleepData = SleepData(Time: -1, slept: Date.now, woke: Date.now)
        
        let sleepType = HKCategoryType(.sleepAnalysis)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) in
                if error != nil{
                    print("Error")
                    return
                }
                if let result = tmpResult{
                    for item in result {
                        //TODO: Parse results and create real SleepData
                        //NOTE: Query should keep sampling until we reach the point when the user was not asleep
                        if let sample = item as? HKCategorySample{
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue)
                            print("Healthkit Sleep: \(sample.startDate) \(sample.endDate) - value \(value)")
                        }
                    }
                }
        }
        
        //TODO: Queries happen async, we need to find a way for the main thread to wait before returning
        self.HKStore.execute(sampleQuery)
        return retSleepData
    }
    
    
    public func retrieveData(_ number: Int = 20) -> SleepData{
        //Get data from Apple health data
        assert(HKHealthStore.isHealthDataAvailable(), "Error: No data available")
        return executeQuery()
    }
    
    
}

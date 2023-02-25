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
        let typesToRead = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        ])
        
        self.HKStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
                if !success{
                    print("Authorization failed")
                }
                else if success{
                    print("Authorization succeeded")
                }
        }
        print("Finish getting permissions")
    }
    
    private func executeQuery(_ number: Int) -> Void {
        //Create query to get sleep data of most recent sleep
        // Params:
        //      number: Amount of data to retrieve, default 20
        var retSleepData = SleepData(Time: -1, slept: Date.now, woke: Date.now)
        
        let sleepType = HKCategoryType(.sleepAnalysis)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let sampleQuery = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: number, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) in
                //TODO: How to get values out of callback function?
                //TODO: Analyze healkit api retrieved data deeper and see what causes gaps in inBed status
                retSleepData.Time = 1
                if error != nil{
                    print("Error")
                    return
                }
                if let result = tmpResult{
                    if let sample = result[0] as? HKCategorySample{
                        let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue)
                        retSleepData.slept = sample.startDate
                        retSleepData.woke = sample.endDate
                    }
                    for item in result[1...] {
                        if let sample = item as? HKCategorySample{
                            
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue)
                            
                            print("Healthkit Sleep:\n\t \(sample.startDate)\n\t \(sample.endDate) \n\t- value \(value)")
                            if (self.timeBetweenDates(retSleepData.slept, sample.endDate) <= 1.5){
                                retSleepData.slept = sample.startDate
                            }
                            else{
                                break
                            }
                        }
                    }
                    retSleepData.Time = self.timeBetweenDates(retSleepData.woke, retSleepData.slept)
                    // ^^ this ret sleep data is the sleep data for the day
                }
        }
        
        //TODO: Queries happen async, need to work around it
        self.HKStore.execute(sampleQuery)
        //TODO: Discuss what should happen if the query gets the users sleep data wrong, should it prompt user the enter manually?
    }
    
    
    public func retrieveData(_ number: Int = 20) -> Void{
        //Get data from Apple health data
        assert(HKHealthStore.isHealthDataAvailable(), "Error: No data available")
        executeQuery(number)
    }
    
    private func timeBetweenDates(_ endDate: Date, _ startDate: Date) -> Double {
        return endDate.timeIntervalSince(startDate) / 3600
    }
}

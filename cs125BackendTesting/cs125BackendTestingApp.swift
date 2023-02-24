//
//  cs125BackendTestingApp.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import SwiftUI

@main
struct cs125BackendTestingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear{
                start()
            }
        }
    }
}

func start(){
    let sleepDatabase = UserSleepDatabase()
    
    print("1. Inserting one piece of data")
    let userCalendar = Calendar.current
    var dateComponent = DateComponents()
    dateComponent.year = 2023
    dateComponent.month = 2
    dateComponent.day = 22
    dateComponent.hour = 23
    dateComponent.minute = 0
    let sleepDate = userCalendar.date(from: dateComponent)
    dateComponent.year = 2023
    dateComponent.month = 2
    dateComponent.day = 23
    dateComponent.hour = 7
    dateComponent.minute = 0
    let wokeDate = userCalendar.date(from: dateComponent)
    let testSleepData = SleepData(Time: 8, slept: sleepDate!, woke: wokeDate!)
    
    sleepDatabase.addData(date: sleepDate!, data: testSleepData)
    let retData = sleepDatabase.getData(date: sleepDate!)
    assert(retData.Time == testSleepData.Time &&
           retData.slept == testSleepData.slept &&
           retData.woke == testSleepData.woke,
           "Error, returned data was not the same as inserted data"
    )
    print("Test 1 successful")
}

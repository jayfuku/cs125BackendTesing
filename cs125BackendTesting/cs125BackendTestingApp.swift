//
//  cs125BackendTestingApp.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 2/22/23.
//

import SwiftUI
import HealthKit

@main
struct cs125BackendTestingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear{
//                start()
//                retrievalTest()
                recommendationTest()
            }
        }
    }
}

func recommendationTest(){
    let personalModel = PersonalModel()
    let (dateData, sleptData) = consistentData(7) //Generate 50 pieces of data all with consistent sleep
    for i in 0..<sleptData.count{
        personalModel.updateAll(data: sleptData[i])
    }
    print(sleptData)
    let recommendationModel = RecommendationAlgorithm(personalModel)
    for i in recommendationModel.recommend(){
        print(i.0, "\n", i.1, "\n", i.2, "\n")
    }
}

func retrievalTest()  -> Void {
    let retriever = UserSleepDataRetriever()
    retriever.retrieveData(20)
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
    var retData = sleepDatabase.getData(date: sleepDate!)
    assert(retData.Time == testSleepData.Time &&
           retData.slept == testSleepData.slept &&
           retData.woke == testSleepData.woke,
           "Error: returned data was not the same as inserted data"
    )
    print("Test 1 successful\n")
    
    //TESTING FOR ERRORS, NOT ACCURACY
    print("2. Inserting 7 pieces of random data")
    var (dateData, sleptData) = randomData(7)
    print("Testing 7 insertions")
    for i in 0..<sleptData.count{
        sleepDatabase.addData(date: dateData[i], data: sleptData[i])
    }
    print("Insertions complete")
    print("Attempting to retrieve all data")
    for i in 0..<sleptData.count{
        retData = sleepDatabase.getData(date: dateData[i])
    }
    print("Test 2 successful\n")
    
    //TESTING FOR ERRORS, NOT ACCURACY
    print("3. Inserting 100 pieces of random data")
    (dateData, sleptData) = randomData(100)
    print("Testing 100 insertions")
    for i in 0..<sleptData.count{
        sleepDatabase.addData(date: dateData[i], data: sleptData[i])
    }
    print("Insertions complete")
    print("Attempting to retrieve all data")
    for i in 0..<sleptData.count{
        retData = sleepDatabase.getData(date: dateData[i])
    }
    print("Test 3 complete\n")
    
    
    print("Testing personal model with consistent data")
    let personalModel = PersonalModel()
    (dateData, sleptData) = randomData(50) //Generate 50 pieces of data all with consistent sleep
    for i in 0..<sleptData.count{
        personalModel.updateAll(data: sleptData[i])
    }
    
    print("1. ConsistentSleep")
    //assert(personalModel.getConsistentSleep(), "Error: Mocked data should be returning true for consistent sleep")
    print("Test 1 Complete")
    print("2. GoodSleepAmount")
    //assert(personalModel.getGoodSleepAmnt(), "Errpr: Mocked data should be returning true for good sleep amount")
    print("Test 2 complete\n")
    
    print("Testing Personal Model with random but sensible data")
    personalModel._clearModel()
    (dateData, sleptData) = goodRandomData(50)
    for i in 0..<sleptData.count{
        personalModel.updateAll(data: sleptData[i])
    }
    print(String(repeating:"-", count: 20))
    print("PASTE INTO STANDARD DEVIATION or AVERAGE CALCULATOR FOR MANUAL VERIFICATION")
    for i in 0..<sleptData.count{
        print(String(sleptData[i].Time) + ", ", terminator: "")
    }
    print("\n")
    print(String(repeating:"-", count: 20))
    print("Result of consistent sleep with 50 pieces of sensible data:", personalModel.getConsistentSleep())
    print("Result of goodSleepAmnt with 50 pieces of snesible data:", personalModel.getGoodSleepAmnt())
    print("Complete\n")
    
    //TESTING FOR ERRORS NOT ACCURACY
    print("Testing Calendar")
    let calendar = UserCalendar()
    print("Testing single event insertion and retrieval")
    let testDate = Date.now
    calendar.addEvent(testDate, "Do Laundry", "I really need to do laundry")
    var event = calendar.getEventByDay(testDate)
    print("Test complete")
    print("Testing 100 insertions and retrievals")
    (dateData, sleptData) = randomData(100)
    for i in dateData{
        calendar.addEvent(i, "TEST", "TESTING123")
    }
    print("Insertions Complete")
    for i in dateData{
        event = calendar.getEventByDay(i)
    }
    print("Retrievals complete\n")
    
    print("Testing calendar storage")
    LocalStorageInterface.setCalendarDatabase(calendar)
    print(LocalStorageInterface.retrieveCalendarDatabase() as Any)
    
    print("Testing sleepDatabase storage")
    LocalStorageInterface.setUserSleepDatabase(sleepDatabase)
    print(LocalStorageInterface.retrieveUserSleepDatabase() as Any)
    
    
}

func randomData(_ number: Int) -> ([Date], [SleepData]) {
    //Generate nonsensical random data
    var sleepData: [SleepData] = []
    var dateData: [Date] = []
    let userCalendar = Calendar.current
    var dateComponent = DateComponents()
    for _ in 0..<number{
        dateComponent.year = Int.random(in: 2022...2023)
        dateComponent.month = Int.random(in: 1...12)
        dateComponent.day = Int.random(in: 1...28)
        dateComponent.hour = Int.random(in: 0...24)
        dateComponent.minute = Int.random(in: 0...59)
        let sleptDate = userCalendar.date(from: dateComponent)
        dateComponent.year = Int.random(in: 2022...2023)
        dateComponent.month = Int.random(in: 1...12)
        dateComponent.day = Int.random(in: 1...28)
        dateComponent.hour = Int.random(in: 0...24)
        dateComponent.minute = Int.random(in: 0...59)
        let wokeDate = userCalendar.date(from:dateComponent)
        sleepData.append(SleepData(Time: Double(Int.random(in: 1...8)), slept: sleptDate!, woke: wokeDate!))
        dateData.append(sleptDate!)
    }
    return (dateData, sleepData)
}

func goodRandomData(_ number: Int) -> ([Date], [SleepData]) {
    //Generate sensical random data
    var sleepData: [SleepData] = []
    var dateData: [Date] = []
    let userCalendar = Calendar.current
    var dateComponent = DateComponents()
    for _ in 0..<number{
        var sleptHours = 0
        dateComponent.year = Int.random(in: 2022...2023)
        dateComponent.month = Int.random(in: 1...12)
        dateComponent.day = Int.random(in: 1...28)
        dateComponent.hour = Int.random(in: 22...24)
        dateComponent.minute = 0
        sleptHours = 24 - dateComponent.hour!
        let sleptDate = userCalendar.date(from: dateComponent)
        dateComponent.year = Int.random(in: 2022...2023)
        dateComponent.month = Int.random(in: 1...12)
        dateComponent.day = Int.random(in: 1...28)
        dateComponent.hour = Int.random(in: 6...8)
        dateComponent.minute = 0
        sleptHours += dateComponent.hour!
        let wokeDate = userCalendar.date(from:dateComponent)
        sleepData.append(SleepData(Time: Double(sleptHours), slept: sleptDate!, woke: wokeDate!))
        dateData.append(sleptDate!)
    }
    return (dateData, sleepData)
}

func consistentData(_ number: Int) -> ([Date], [SleepData]){
    //Generate data with consistent sleep times
    var sleepData: [SleepData] = []
    var dateData: [Date] = []
    let userCalendar = Calendar.current
    var dateComponent = DateComponents()
    for _ in 0..<number{
        dateComponent.year = Int.random(in: 2022...2023)
        dateComponent.month = Int.random(in: 1...12)
        dateComponent.day = Int.random(in: 1...28)
        dateComponent.hour = Int.random(in: 0...24)
        dateComponent.minute = Int.random(in: 0...59)
        let sleptDate = userCalendar.date(from: dateComponent)
        dateComponent.year = Int.random(in: 2022...2023)
        dateComponent.month = Int.random(in: 1...12)
        dateComponent.day = Int.random(in: 1...28)
        dateComponent.hour = Int.random(in: 0...24)
        dateComponent.minute = Int.random(in: 0...59)
        let wokeDate = userCalendar.date(from:dateComponent)
        sleepData.append(SleepData(Time: 8, slept: sleptDate!, woke: wokeDate!))
        dateData.append(sleptDate!)
    }
    return (dateData, sleepData)
}

func compareSleepData( _ one: SleepData, _ two: SleepData) -> Bool{
    //Helper function to compare two SleepData
    return one.slept == two.slept && one.woke == two.woke && one.Time == two.Time
}

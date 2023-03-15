//
//  LocalStorageRetriever.swift
//  cs125BackendTesting
//
//  Created by Jay Fukumoto on 3/9/23.
//

import Foundation

class LocalStorageInterface {
    
    public static func setUserSleepDatabase(_ s : UserSleepDatabase) -> Void {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(s){
            userDefaults.set(data, forKey:"SleepDatabase")
        }
        
    }
    public static func retrieveUserSleepDatabase() -> UserSleepDatabase?{
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let obj = userDefaults.object(forKey:"SleepDatabase") as? Data{
            if let parsedObj = try? decoder.decode(UserSleepDatabase.self, from: obj){
                return parsedObj
            }
        }
        return nil
    }

    public static func setCalendarDatabase(_ c : UserCalendar) -> Void {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(c) {
            userDefaults.set(data, forKey: "UserCalendar")
        }

    }

    public static func retrieveCalendarDatabase() -> UserCalendar? {
        let userDefaults = UserDefaults.standard
        let decoder  = JSONDecoder()
        if let obj = userDefaults.object(forKey: "UserCalendar") as? Data{
            if let parsedObj = try? decoder.decode(UserCalendar.self, from: obj){
                return parsedObj
            }
        }
        return nil
    }
    
    
    public static func setPersonalModel(_ p : PersonalModel) -> Void{
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(p) {
            userDefaults.set(data, forKey: "PersonalModel")
        }
    }
    
    public static func retrievePersonalModel() -> PersonalModel? {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let obj = userDefaults.object(forKey: "PersonalModel") as? Data{
            if let parsedObj = try? decoder.decode(PersonalModel.self, from: obj){
                return parsedObj
            }
        }
        return nil
    }
}

//
//  DataStore.swift
//  HantongWatch WatchKit Extension
//
//  Created by SONGKIWON on 2020/05/14.
//  Copyright © 2020 intosharp. All rights reserved.
//

import UIKit

private let kTodaySum        = "hantongwatch_today_sum"
private let kYesterdaySum    = "hantongwatch_yesterday_sum"
private let kThisMonthSum    = "hantongwatch_this_month_sum"
private let kLastMonthSum    = "hantongwatch_last_month_sum"
private let kLastUpdateDate  = "hantongwatch_LastUpdateDate"
private let kSeverUpdateDate = "hantongwatch_SeverUpdateDate"
private let kSeverPassword   = "hantongwatch_SeverPassword"

private let kPercent         = "hantongwatch_Percent"
private let kGoal            = "hantongwatch_Goal"

private let kUnlockDate      = "hantongwatch_UnlockDate"

class DataStore: NSObject {
    
    var goals : Array<Double>  = [0.0, 235551150.0,295263006.0,488964370.0,454540910.0,342788256.0,398429928.0,401174097.0,408472364.0,518397129.0,540379250.0,466737737.0,591121193.0]
    
    let defaults = UserDefaults.standard
    
    var todaySum: Int? {
        get {
            return defaults.object(forKey: kTodaySum) as? Int
        }
        set {
            defaults.set(newValue, forKey: kTodaySum)
        }
    }
    
    var yesterdaySum: Int? {
        get {
            return defaults.object(forKey: kYesterdaySum) as? Int
        }
        set {
            defaults.set(newValue, forKey: kYesterdaySum)
        }
    }
    
    var thisMonthSum: Int? {
        get {
            return defaults.object(forKey: kThisMonthSum) as? Int
        }
        set {
            defaults.set(newValue, forKey: kThisMonthSum)
        }
    }
    
    var lastMonthSum: Int? {
        get {
            return defaults.object(forKey: kLastMonthSum) as? Int
        }
        set {
            defaults.set(newValue, forKey: kLastMonthSum)
        }
    }
    
    var lastUpdateDate: Date? {
        get {
            return defaults.object(forKey: kLastUpdateDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: kLastUpdateDate)
        }
    }
    
    var serverUpdateDate: Date? {
        get {
            return defaults.object(forKey: kSeverUpdateDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: kSeverUpdateDate)
        }
    }
    
    var serverPassword: String? {
        get {
            return defaults.object(forKey: kSeverPassword) as? String
        }
        set {
            defaults.set(newValue, forKey: kSeverPassword)
        }
    }
    
    var percent: String? {
        get {
            return defaults.object(forKey: kPercent) as? String
        }
        set {
            defaults.set(newValue, forKey: kPercent)
        }
    }
    
    var goal: String? {
        get {
            return defaults.object(forKey: kGoal) as? String
        }
        set {
            defaults.set(newValue, forKey: kGoal)
        }
    }
    
    var unlockDate: Date? {
        get {
            return defaults.object(forKey: kUnlockDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: kUnlockDate)
        }
    }
 
    func checkUnlockDate() -> Bool  {
        if let unlockDate = self.unlockDate {
            let useTime = Int(Date().timeIntervalSince(unlockDate)) / 60

            // 락 걸리는 시간 160시간 (약 1주일)
            if useTime >= 9600 {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                return true
            }
        }
        return false
    }
}

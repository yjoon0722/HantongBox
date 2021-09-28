//
//  DataStore.swift
//  Runner
//
//  Created by yjoon on 2020/12/07.
//  Copyright © 2020 The Flutter Authors. All rights reserved.
//

import WidgetKit

private let kTodaySum        = "hantongwatch_today_sum"
private let kYesterdaySum    = "hantongwatch_yesterday_sum"
private let kThisMonthSum    = "hantongwatch_this_month_sum"
private let kLastMonthSum    = "hantongwatch_last_month_sum"
private let kLastUpdateDate  = "hantongwatch_LastUpdateDate"
private let kSeverUpdateDate = "hantongwatch_SeverUpdateDate"
private let kSeverPassword   = "hantongwatch_SeverPassword"

private let kUnlockDate      = "hantongwatch_UnlockDate"

class DataStore: NSObject {
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
            
            if useTime >= 720 {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                return true
            }
        }
        return false
    }
}

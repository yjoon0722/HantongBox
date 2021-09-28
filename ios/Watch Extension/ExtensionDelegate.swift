//
//  ExtensionDelegate.swift
//  HantongWatch WatchKit Extension
//
//  Created by SONGKIWON on 2020/05/07.
//  Copyright © 2020 intosharp. All rights reserved.
//

import WatchKit
import ClockKit

private let MinimumIntervalBetweenUpdates: TimeInterval = 15 * 60

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    let dataStore = DataStore()
    let api: API = API.sharedInstance
    
    var canUpdateDataNow: Bool {
        if let lastUpdate = dataStore.lastUpdateDate {
            return Date().timeIntervalSince(lastUpdate) > 5 * 60
        } else {
            return true
        }
    }
    
    func applicationDidFinishLaunching() {
        debugPrint("ExtensionDelegate - applicationDidFinishLaunching")
        scheduleNextReload()
    }

    func applicationDidBecomeActive()       {
        debugPrint("ExtensionDelegate - applicationDidBecomeActive")
        if canUpdateDataNow {
            self.api.todayAndTishMonthSum { () in
                self.reloadActiveComplications()
            }
        } else {
            NSLog("ExtensionDelegate: not loading data since it was last updated at \(dataStore.lastUpdateDate!)")
        }
    }
    
    func applicationWillResignActive()      { debugPrint("ExtensionDelegate - applicationWillResignActive") }
    func applicationWillEnterForeground()   { debugPrint("ExtensionDelegate - applicationWillEnterForeground") }
    func applicationDidEnterBackground()    {
        debugPrint("ExtensionDelegate - applicationDidEnterBackground")
        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: Date(),
            userInfo: nil,
            scheduledCompletion: { error in
                let message = error == nil ? "scheduled successfully" : "NOT scheduled: \(error!)"
                debugPrint("scheduleNextReload - scheduleBackgroundRefresh : \(message)")
                
                self.reloadActiveComplications()
                
            }
        )
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        debugPrint("ExtensionDelegate - WKRefreshBackgroundTask")
        
        for task in backgroundTasks {
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                debugPrint("ExtensionDelegate - backgroundTask")
                
                scheduleNextReload()
                
                self.api.todayAndTishMonthSum { () in
                    self.reloadActiveComplications()
                    debugPrint("ExtensionDelegate - handle : WKApplicationRefreshBackgroundTask completed")
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                }
                
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                debugPrint("ExtensionDelegate - snapshotTask")
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                debugPrint("ExtensionDelegate - connectivityTask")
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                debugPrint("ExtensionDelegate - urlSessionTask")
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                debugPrint("ExtensionDelegate - relevantShortcutTask")
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                debugPrint("ExtensionDelegate - intentDidRunTask")
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                debugPrint("ExtensionDelegate - default")
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    // MARK: - Class methods
    
    func scheduleNextReload() {
        let nextReloadTime = Date(timeIntervalSinceNow: MinimumIntervalBetweenUpdates)
        debugPrint("scheduleNextReload - Date : %@", "\(Date().display)")
        debugPrint("scheduleNextReload - nextReloadTime : %@", "\(nextReloadTime.display)")
        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: nextReloadTime,
            userInfo: nil,
            scheduledCompletion: { error in
                let message = error == nil ? "scheduled successfully" : "NOT scheduled: \(error!)"
                debugPrint("scheduleNextReload - scheduleBackgroundRefresh : \(message)")
            }
        )
    }
    
    func reloadActiveComplications() {
        debugPrint("ExtensionDelegate: requesting reload of complications")
        let server = CLKComplicationServer.sharedInstance()
        for complication in server.activeComplications ?? [] {
            debugPrint("ExtensionDelegate - reloadActiveComplications : %@", complication.family.description)
            server.reloadTimeline(for: complication)
        }
    }
    
}

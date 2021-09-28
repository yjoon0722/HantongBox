//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by SONGKIWON on 2020/08/24.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import WatchKit
import Foundation
//import Alamofire

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tableView: WKInterfaceTable!
    
    let dataStore = DataStore()
    let api: API = API.sharedInstance
    
    var isReload: Bool = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        debugPrint("InterfaceController - awake")
    }
    
    override func willActivate() {
        super.willActivate()
        debugPrint("InterfaceController - willActivate")
        
        dataStore.checkUnlockDate()
        
        if dataStore.unlockDate != nil {
            isReload = false
            touchedReload()
        } else {
            WKInterfaceController.reloadRootControllers(withNamesAndContexts:
            [(name: "PasscodeInterfaceController", context: PasscodeInterfaceController.self)])
        }
    }
    
    override func didAppear() {
        super.didAppear()
        debugPrint("InterfaceController - didAppear")
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        debugPrint("InterfaceController - didDeactivate")
    }
    
    // MARK: Actions
  
    /*/ 테이블 터치
    @IBAction func pressTableView(_ sender: WKLongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        debugPrint("pressTableView")
        touchedReload()
    }
    
    // 테이블 롱터치
    @IBAction func longPressTableView(_ sender: WKLongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        debugPrint("longPressTableView")
        touchedReload()
    }
    // */
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        debugPrint("didSelectRowAt")
        touchedReload()
    }
    
    // Reload Button
    @IBAction func touchedReload() {
        guard isReload == false else {
            debugPrint("로딩중입니다.")
            return
        }
        
        isReload = true
        
        // 판매 현황 데이터 가져오기
        api.sales_status { (error) in
            if let error = error {
                debugPrint("failed get logs: \(error.localizedDescription)")
            } else {
                self.dataStore.lastUpdateDate = Date()
            }
            
            self.isReload = false
            
            DispatchQueue.global().async {
                self.loadTableData()
            }
        }
    }
    
    // MARK: TableData
    
    private func loadTableData() {
        
        let rowCount = 8
        
        tableView.setNumberOfRows(rowCount, withRowType: "FieldsTableRowController")
        
        var titleColor = UIColor.white
        var subColor = UIColor.white
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "M"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        // 서버 시간과 조희 시간 비교
        if let serverUpdateDate = self.dataStore.serverUpdateDate {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.minute], from: serverUpdateDate, to: Date())
            if let minute = dateComponents.minute, minute >= 10 {
                titleColor = UIColor.gray
                subColor = UIColor.gray
            }
        }
        
        for index in 0...rowCount-1 {
            
            let row = tableView.rowController(at: index) as! FieldsTableRowController
            row.detailLabel.setHidden(true)
            row.subLabel.setHidden(true)
                        
            switch index {
            case 0:
                row.titleLabel.setText("금일(\(dateFormatter.string(from:Date())))")
                row.titleLabel.setTextColor(titleColor)
                row.detailLabel.setText(self.dataStore.todaySum?.decimalType())
                row.detailLabel.setTextColor(subColor)
                row.detailLabel.setHidden(false)
                
            case 1:
                row.titleLabel.setText("전일")
                row.titleLabel.setTextColor(titleColor)
                row.detailLabel.setText(self.dataStore.yesterdaySum?.decimalType())
                row.detailLabel.setTextColor(subColor)
                row.detailLabel.setHidden(false)
                
            case 2:
                row.titleLabel.setText("당월(\(monthFormatter.string(from: Date())))")
                row.titleLabel.setTextColor(titleColor)
                row.detailLabel.setText(self.dataStore.thisMonthSum?.decimalType())
                row.detailLabel.setTextColor(subColor)
                row.detailLabel.setHidden(false)
                
            case 3:
                row.titleLabel.setText("전월")
                row.titleLabel.setTextColor(titleColor)
                row.detailLabel.setText(self.dataStore.lastMonthSum?.decimalType())
                row.detailLabel.setTextColor(subColor)
                row.detailLabel.setHidden(false)
                
            case 4:
                var detailString = ""
                if let this_month_sum = self.dataStore.thisMonthSum {
                    let date = Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.day], from: date)
                    if let day = components.day, day > 0 {
                        detailString = "\(this_month_sum / day)".decimalType()
                    }
                }
                row.titleLabel.setText("평균")
                row.titleLabel.setTextColor(titleColor)
                row.detailLabel.setText(detailString)
                row.detailLabel.setTextColor(subColor)
                row.detailLabel.setHidden(false)
                
            case 5:
                row.titleLabel.setText("목표(\(self.dataStore.percent ?? ""))")
                row.titleLabel.setTextColor(titleColor)
                row.detailLabel.setText("\(self.dataStore.goal ?? "")")
                row.detailLabel.setTextColor(subColor)
                row.detailLabel.setHidden(false)
                
            case 6:
                // 조회시간
                row.titleLabel.setText("갱신")
                row.subLabel.setText(Date().display)
                row.subLabel.setHidden(false)
                
            case 7:
                // 서버에 저장된 시간
                row.titleLabel.setText("서버")
                row.subLabel.setText(self.dataStore.serverUpdateDate?.display)
                row.subLabel.setHidden(false)
                
            default:
                debugPrint("default")
                row.titleLabel.setText("")
                row.detailLabel.setText("")
            }
        }
    }
}

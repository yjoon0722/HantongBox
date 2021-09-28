//
//  Widget_Extension.swift
//  Widget Extension
//
//  Created by SONGKIWON on 2020/09/29.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI

struct WidgetModel: TimelineEntry {
    var date: Date
    var detailString: String
}

struct DataProvider: TimelineProvider  {
    let dataStore = DataStore()
    let api: API = API.sharedInstance
        
    func placeholder(in context: Context) -> WidgetModel {
        debugPrint(#function)
        return WidgetModel(date: Date(), detailString: "")
    }
        
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetModel>) -> Void) {
        debugPrint(#function)
        
        let date = Date()
        
        // 판매 현황 데이터 가져오기
        api.sales_status { (error) in
            if let error = error {
                debugPrint("failed get logs: \(error.localizedDescription)")
            } else {
                self.dataStore.lastUpdateDate = Date()
            }
            
            var detailString = ""
            if let this_month_sum = self.dataStore.thisMonthSum {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: date)
                if let day = components.day, day > 0 {
                    detailString = "\(this_month_sum / day)".decimalType()
                }
            }
            
            let entryData = WidgetModel(date: date, detailString: detailString)
            
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 10, to: date)!
            let timeLine = Timeline(entries: [entryData], policy: .after(nextUpdateDate))
            debugPrint("updated: \(date), next: \(nextUpdateDate)")
            
            completion(timeLine)
        }
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetModel) -> Void) {
        debugPrint(#function)
        
        let date = Date()
        let entryData = WidgetModel(date: date, detailString: "")
        completion(entryData)
    }
}

struct WidgetView: View {
    let dataStore = DataStore()
    var data: DataProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
        
    var body: some View {
        if isLock() {
            VStack(alignment: .center, spacing: 2) {
                Spacer()
                Text("암호입력하세요")
                    .font(.caption)
                    .foregroundColor(Color.white)
                Spacer()
            }
            .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
            .background(linearGradientBG())
            
        } else {
            switch family {
            case .systemSmall:
                bodySystemSmall(textColor: getTextColor())
            default:
                bodySystemMedium(textColor: getTextColor())
            }
        }
    }
    
    // 위젯 락 걸리는 시간 160시간 (약 1주일)
    func isLock() -> Bool {
        let defaults = UserDefaults(suiteName: "group.com.intosharp.hantongbox")
        defaults?.synchronize()
        guard let lastTime = defaults?.object(forKey: "lastTime") as? Date else { return true }
        let useTime = Int(Date().timeIntervalSince(lastTime)) / 60
        if useTime >= 9600 { return true }
        return false
    }
    
    func getTextColor() -> Color {
        var textColor = Color.white
        if let serverUpdateDate = self.dataStore.serverUpdateDate {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.minute], from: serverUpdateDate, to: Date())
            if let minute = dateComponents.minute, minute >= 10 {
                textColor = Color.gray
            }
        }
        return textColor
    }
    
    private func bodySystemSmall(textColor: Color) -> some View {
        return VStack(alignment: .center, spacing: 2) {
            makeSmallCaptionContent(title: "금일(\(self.data.date.days))", detail: self.dataStore.todaySum?.decimalType() ?? "-", textColor: textColor)
            makeSmallCaptionContent(title: "전일", detail: self.dataStore.yesterdaySum?.decimalType() ?? "-", textColor: textColor)
            makeSmallCaptionContent(title: "당월(\(self.data.date.month))", detail: self.dataStore.thisMonthSum?.decimalType() ?? "-", textColor: textColor)
            makeSmallCaptionContent(title: "전월", detail: self.dataStore.lastMonthSum?.decimalType() ?? "-", textColor: textColor)
            makeSmallCaptionContent(title: "평균", detail: self.data.detailString, textColor: textColor)
            makeSmallCaptionContent(title: "목표(\(self.dataStore.percent ?? ""))", detail: self.dataStore.goal ?? "", textColor: textColor)
            makeSmallCaptionContent(title: "시간", detail: self.data.date.widetDisplay)
            makeSmallCaptionContent(title: "서버", detail: self.dataStore.serverUpdateDate?.widetDisplay ?? "-")
        }
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .background(linearGradientBG())
    }
    
    private func bodySystemMedium(textColor: Color? = Color.white) -> some View {
        return VStack(alignment: .center, spacing: 2) {
            makeCaptionContent(title: "금일(\(self.data.date.days))", detail: self.dataStore.todaySum?.decimalType() ?? "-", textColor: textColor)
            makeCaptionContent(title: "전일", detail: self.dataStore.yesterdaySum?.decimalType() ?? "-", textColor: textColor)
            makeCaptionContent(title: "당월(\(self.data.date.month))", detail: self.dataStore.thisMonthSum?.decimalType() ?? "-", textColor: textColor)
            makeCaptionContent(title: "전월", detail: self.dataStore.lastMonthSum?.decimalType() ?? "-", textColor: textColor)
            makeCaptionContent(title: "평균", detail: self.data.detailString, textColor: textColor)
            makeCaptionContent(title: "목표(\(self.dataStore.percent ?? ""))", detail: self.dataStore.goal ?? "", textColor: textColor)
            makeCaptionContent(title: "시간", detail: self.data.date.widetDisplay)
            makeCaptionContent(title: "서버", detail: self.dataStore.serverUpdateDate?.widetDisplay ?? "-")
        }
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .background(linearGradientBG())
    }
            
    private func linearGradientBG() -> LinearGradient {
        return LinearGradient(gradient:Gradient(colors: [Color.init(hex: "084172"),
                                                         Color.init(hex: "084C82"),
                                                         Color.init(hex: "084C82"),
                                                         Color.init(hex: "115999")]),
                              startPoint: .top, endPoint: .bottom)
    }
    
    private func makeSmallCaptionContent(title: String, detail: String, textColor: Color? = Color.white) -> some View {
        return HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(textColor)
            Spacer()
            Text(detail)
                .font(.caption)
                .foregroundColor(textColor)
        }
    }
    
    private func makeCaptionContent(title: String, detail: String, textColor: Color? = Color.white) -> some View {
        return HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(textColor)
            Spacer()
            Text(detail)
                .font(.caption)
                .foregroundColor(textColor)
        }
    }
}

@main
struct Config: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Widget", provider: DataProvider()) { data in
            WidgetView(data: data)
        }
        // .systemSmall, .systemMedium, .systemLarge
        .supportedFamilies([.systemSmall, .systemMedium])
        .description(Text("Current Time Widget"))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//
//  Extensions.swift
//  Runner
//
//  Created by yjoon on 2020/12/07.
//  Copyright © 2020 The Flutter Authors. All rights reserved.
//

import Foundation

struct SWError: Error {
    let message: String?
}

extension SWError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString("" + (message ?? ""), comment: "")
    }
}

extension String {
    func decimalType() -> String {
        if self.isEmpty || self as AnyObject is NSNull { return "0" }
        if self.count < 3 { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        let formattedAmount = formatter.string(from: formatter.number(from: self)!)
        return formattedAmount!;
    }
}

extension Int {
    func decimalType() -> String {
        let value = String(self)
        return value.decimalType()
    }
}

extension Date {
    var days: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var display: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월dd일 HH:mm"
        return dateFormatter.string(from: self)
    }
    
    var widetDisplay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

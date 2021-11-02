//
//  Date+Extension.swift
//  GAAppUpdate
//
//  Created by MaciOS on 2021/7/23.
//

import Foundation

extension Date {
    
    /// app更新 是否是新的一天
    static func appUpdateIsNewToday() -> Bool {
        let dateStr = UserDefaults.standard.value(forKey: "appUpdateIsNewToday") as? String ?? ""
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowDateStr = dateFormatter.string(from: nowDate)
    
        if dateStr == nowDateStr {
            return false
        }
        UserDefaults.standard.setValue(nowDateStr, forKey: "appUpdateIsNewToday")
        return true
    }
    
}

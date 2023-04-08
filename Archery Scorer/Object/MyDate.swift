//
//  MyDate.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class MyDate: ObservableObject {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date.now)

    @Published var year = 2022
    @Published var month = 2
    @Published var day = 26
    @Published var selectedRange = [NSDate.now, NSDate.now] as [NSDate]
    
    init() {
        year = components.year ?? 2022
        month = components.month ?? 2
        day = components.day ?? 26
    }
    
    func FindStartDate() -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateInString = String(self.year) + "-" + String(self.month) + "-1"
        let date = dateFormatter.date(from: dateInString)!
        return date as NSDate
    }
    
    func FindEndDate() -> NSDate {
        var endDay = 1
        let bigMonths = [1, 3, 5, 7, 8, 10, 12]
        if bigMonths.contains(self.month) {
            endDay = 31
        } else {
            if self.month == 2 && self.year % 4 == 0{
                endDay = 29
            } else if self.month == 2 && self.year % 4 != 0 {
                endDay = 28
            } else {
                endDay = 30
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateInString = String(self.year) + "-" + String(self.month) + "-" + String(endDay) + " 23:59:59"
        let date = dateFormatter.date(from: dateInString)!
        return date as NSDate
    }
    
    func FindToday() -> [NSDate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let startDateInString = String(self.year) + "-" + String(self.month) + "-" + String(self.day) + " 00:00:00"
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(self.year) + "-" + String(self.month) + "-" + String(self.day) + " 23:59:59"
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
}

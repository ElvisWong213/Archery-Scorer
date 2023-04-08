//
//  FilterBarFunction.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class FilterBarFunction {
    func FindTodayRange(year: Int, month: Int, day: Int) -> [NSDate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let startDateInString = String(year) + "-" + String(month) + "-" + String(day) + " 00:00"
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(year) + "-" + String(month) + "-" + String(day) + " 23:59"
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
    
    func FindWeekRange(year: Int, month: Int, day: Int) -> [NSDate] {
        let numberOfDay = CalendarFunction().FindNumberOfDay(year: year, month: month)
        let weekDay = FindWeekDay(year: year, month: month, day: day)
        
        var startYear = year
        var startMonth = month
        var startDay = day
        var endYear = year
        var endMonth = month
        var endDay = day
        
        if weekDay == 6 {
            startDay = day - 6
            if startDay < 1 {
                var preNumberOfDay = 0
                if month == 1 {
                    preNumberOfDay = CalendarFunction().FindNumberOfDay(year: year - 1, month: 12)
                    startYear -= 1
                    startMonth = 12
                }else{
                    preNumberOfDay = CalendarFunction().FindNumberOfDay(year: year, month: month - 1)
                    startMonth -= 1
                }
                startDay += preNumberOfDay
            }
        }else if weekDay == 0 {
            endDay = day + 6
            if endDay > numberOfDay {
                if month == 12 {
                    endYear += 1
                    endMonth = 1
                }else{
                    endMonth += 1
                }
                endDay -= numberOfDay
            }
        }else{
            startDay -= weekDay
            endDay += 6 - weekDay
            if startDay < 1 {
                startMonth -= 1
                if startMonth < 1 {
                    startYear -= 1
                    startMonth = 1
                }
                startDay += CalendarFunction().FindNumberOfDay(year: startYear, month: startMonth)
            }
            if endDay > numberOfDay {
                endDay -= numberOfDay
                endMonth += 1
                if endMonth > 12 {
                    endYear += 1
                    endMonth = 1
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let startDateInString = String(startYear) + "-" + String(startMonth) + "-" + String(startDay)
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(endYear) + "-" + String(endMonth) + "-" + String(endDay)
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
    
    func FindWeekDay(year: Int, month: Int, day: Int) -> Int {
        let startWeekDay = CalendarFunction().FindWeekDay(year: year, month: month)
        var output = (startWeekDay + day) % 7
        if output == 0 {
            output = 6
        }else{
            output -= 1
        }
        return output
    }
    
    func FindMonthRange(year: Int, month: Int) -> [NSDate] {
        let numberOfDay = CalendarFunction().FindNumberOfDay(year: year, month: month)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let startDateInString = String(year) + "-" + String(month) + "-1"
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(year) + "-" + String(month) + "-" + String(numberOfDay)
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
    
    func FindYearRange(year: Int) -> [NSDate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let startDateInString = String(year) + "-1-1"
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(year) + "-12-31"
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
}

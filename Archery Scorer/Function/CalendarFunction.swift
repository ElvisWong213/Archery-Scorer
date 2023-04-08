//
//  CalendarFunction.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class CalendarFunction {
    func FindWeekDay(year: Int, month: Int) -> Int {
        let d = 1
        var m = Int(month)
        let stringYear = String(year)
        var y = (Int(stringYear.suffix(2)) ?? 20)
        let c = (Int(stringYear.prefix(2)) ?? 22) - 1

        if m < 3 {
            m += 12
            y -= 1
        }

        var output = (y + Int(y / 4) + Int(c / 4) - 2 * c + Int(26 * (m + 1) / 10) + d - 1) % 7

        if output == 0 {
            output = 6
        }else{
            output -= 1
        }
        // 0 = Sun, 6 = Sat
        return output
    }
    
    func FindNumberOfDay(year: Int, month: Int) -> Int {
        let bigMonths = [1, 3, 5, 7, 8, 10, 12]
        for i in bigMonths {
            if month == i {
                return 31
            }
        }
        if month == 2 && year % 4 == 0{
            return 29
        }else if month == 2 && year % 4 != 0 {
            return 28
        }
        else{
            return 30
        }
    }
    
    func DayInArray(year: Int, month: Int) -> [[Int]] {
        let firstDayIndex = FindWeekDay(year: year, month: month)
        let numberOfDay = FindNumberOfDay(year: year, month: month)
        var dayArray:[[Int]] = [[]]
        var dummy: [Int] = []
        var dayCounter = 0
        
        for i in 0..<7 {
            if i >= firstDayIndex{
                dummy.append(dayCounter + 1)
                dayCounter += 1
            }else{
                dummy.append(0)
            }
        }
        dayCounter = 0
        dayArray.append(dummy)
        dummy.removeAll()
        let startDay = 7 - firstDayIndex + 1
        for i in startDay...numberOfDay {
            dummy.append(i)
            dayCounter += 1
            if i == numberOfDay && dayCounter < 7 {
                for _ in dayCounter..<7 {
                    dummy.append(0)
                }
                dayArray.append(dummy)
            }
            if dayCounter > 6 {
                dayCounter = 0
                dayArray.append(dummy)
                dummy.removeAll()
            }
        }
        return dayArray
    }
}

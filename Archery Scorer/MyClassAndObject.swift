//
//  MyEnvironmentObject.swift
//  Archery Scorer
//
//  Created by Steve on 23/3/2022.
//

import Foundation
import SwiftUI

struct ScoreData {
    var score: String?
    var location: CGPoint?
    
    init (score: String, location: CGPoint) {
        self.score = score
        self.location = location
    }
}

class ScoreDataFunction {
    func DefindValue(input: String) -> Int {
        var output = 0
        if input == "M" {
            output = 0
        }else if input == "X" {
            output = 10
        }else if input == "" {
            output = 0
        }else{
            output = Int(input) ?? 0
        }
        return output
    }
    
    func ThreeArrowTotal(scoreDate: [[ScoreData]], i: Int, row: Int) -> Int {
        var range = 0..<3
        var output = 0
        
        if row == 1 {
            range = 3..<6
        }else{
            range = 0..<3
        }
        
        for j in range {
            let dummy = scoreDate[i][j].score!
            output += DefindValue(input: dummy)
        }
        return output
    }
    
    func SixArrowTotal(scoreDate: [[ScoreData]], i: Int) -> Int {
        let range = 0..<6
        var output = 0
        
        for j in range {
            let dummy = scoreDate[i][j].score!
            output += DefindValue(input: dummy)
        }
        return output
    }
    
    func TotalScore(scoreData: [[ScoreData]]) -> Int {
        var output = 0
        for i in scoreData {
            for j in i {
                output += DefindValue(input: j.score! )
            }
        }
        return output
    }
    
    func AverageScore(scoreData: [[ScoreData]], countNilValue: Bool) -> Double {
        var output: Double = 0
        var counter = 0
        for i in scoreData {
            for j in i {
                if countNilValue == false {
                    if j.score != "" {
                        counter += 1
                    }
                }
                if countNilValue == true {
                    counter += 1
                }
                output += Double(DefindValue(input: j.score! ))
            }
        }
        if counter == 0 {
            output = 0
        }else{
            output = output / Double(counter)
        }
        return output
    }
    
    func FindXTimes(scoreData: [[ScoreData]]) -> Int {
        var output = 0
        for i in scoreData {
            for j in i {
                if j.score == "X" {
                    output += 1
                }
            }
        }
        return output
    }
    
    func FlatScoreData(scoreData: [[ScoreData]]) -> [String] {
        var output: [String] = []
        for i in scoreData {
            for j in i {
                output.append(j.score!)
            }
        }
        return output
    }
    
    func AverageScoreEachRound(scoreData: [[ScoreData]]) -> [Double] {
        var output: [Double] = []
        for i in scoreData {
            output.append(AverageScore(scoreData: [i], countNilValue: true))
        }
        return output
    }
}

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

class FilterBarFunction {
    func FindTodayRange(year: Int, month: Int, day: Int) -> [NSDate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
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
        let startDateInString = String(year) + "-" + String(month) + "-1"
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(year) + "-" + String(month) + "-" + String(numberOfDay)
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
    
    func FindYearRange(year: Int) -> [NSDate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateInString = String(year) + "-1-1"
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(year) + "-12-31"
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
}


// ObservableObject

class BaseViewModel: ObservableObject {
    @Published var baseView: UserFlow = .home

    enum UserFlow {
        case home, add, record, review, statistic
    }
}

class StartData: ObservableObject {
    @Published var time = Date.now
    @Published var distance = ""
    @Published var scoringMethod = "6"
}

class CoreDataGameID: ObservableObject {
    @Published var gameID: String = UUID().uuidString
    @Published var edit = false
    @Published var scoreData: [[ScoreData]] = Array(repeating: Array(repeating: ScoreData(score: "", location: CGPoint.init(x: -1, y: -1)), count: 6), count: 6)
}

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
        let dateInString = String(self.year) + "-" + String(self.month) + "-" + String(endDay) + " 23:59:59"
        let date = dateFormatter.date(from: dateInString)!
        return date as NSDate
    }
    
    func FindToday() -> [NSDate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDateInString = String(self.year) + "-" + String(self.month) + "-" + String(self.day) + " 00:00:00"
        let startDate = dateFormatter.date(from: startDateInString)!
        let endDateInString = String(self.year) + "-" + String(self.month) + "-" + String(self.day) + " 23:59:59"
        let endDate = dateFormatter.date(from: endDateInString)!
        return [startDate, endDate] as [NSDate]
    }
}

// screenshot function
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

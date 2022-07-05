//
//  Calendar.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI
import CoreData

struct AppCalendar: View {
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let backgroundColor3 = Color("BackgroundColor3")
    let textColor = Color("TextColor")
    let buttonColor = Color("ButtonColor")
    
    @EnvironmentObject var myDate: MyDate
    @FetchRequest var games: FetchedResults<Game>
    @State var calendarFunction = CalendarFunction()
    
    let weekDays = [NSLocalizedString("Sun", comment: ""), NSLocalizedString("Mon", comment: ""), NSLocalizedString("Tue", comment: ""), NSLocalizedString("Wed", comment: ""), NSLocalizedString("Thu", comment: ""), NSLocalizedString("Fri", comment: ""), NSLocalizedString("Sat", comment: "")]
    @State var dayArray: [[Int]] = [[]]
    
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date.now)
    
    @State var todayYear = 2022
    @State var todayMonth = 2
    @State var todayDay = 26
    
    init(startDate: NSDate, endDate: NSDate) {
        _games = FetchRequest<Game>(sortDescriptors: [], predicate: NSPredicate(format: "(time >= %@) AND (time <= %@)", startDate, endDate))
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            GeometryReader { gr in
                let buttonSize = gr.size.width / 14
                VStack {
                    ZStack {
                        HStack {
                            Button {
                                myDate.year = components.year ?? 2022
                                myDate.month = components.month ?? 2
                                myDate.day = components.day ?? 26
                                dayArray = calendarFunction.DayInArray(year: myDate.year, month: myDate.month)
                            } label: {
                                Text("Today")
                                    .foregroundColor(buttonColor)
                            }
                            Spacer()
                        }
                        Text("\(String(myDate.day))/\(String(myDate.month))/\(String(myDate.year))")
                            .font(.title)
                    }
                    .padding(.horizontal)
                    HStack {
                        ForEach(weekDays, id: \.self) { days in
                            Spacer()
                            Text(days)
                                .frame(width: buttonSize < 40 ? 40 : buttonSize, height: buttonSize)
                            Spacer()
                        }
                    }
                    ForEach(0..<dayArray.count, id: \.self) { weeks in
                        HStack {
                            ForEach(dayArray[weeks], id: \.self) { days in
                                Spacer()
                                Button {
                                    myDate.day = days
                                }label: {
                                    if days != 0 {
                                        ZStack {
                                            if CheckCalendarInCoreData(day: days) {
                                                Circle()
                                                    .frame(width: buttonSize, height: buttonSize)
                                                    .foregroundColor(backgroundColor2)
                                            }
                                            if days == todayDay && myDate.month == todayMonth && myDate.year == todayYear {
                                                Circle()
                                                    .frame(width: buttonSize, height: buttonSize)
                                                    .foregroundColor(backgroundColor3)
                                            }
                                            if days == myDate.day {
                                                Circle()
                                                    .frame(width: buttonSize, height: buttonSize)
                                                    .foregroundColor(buttonColor)
                                            }
                                            Text(String(days))
                                        }
                                    }else{
                                        Text("")
                                    }
                                }
                                .frame(width: buttonSize, height: buttonSize)
                                Spacer()
                            }
                        }
                    }
                }
                .foregroundColor(textColor)
            }
        }
        .onAppear() {
            todayYear = components.year ?? 2022
            todayMonth = components.month ?? 2
            todayDay = components.day ?? 26
            dayArray = calendarFunction.DayInArray(year: myDate.year, month: myDate.month)
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ value in
            if value.translation.width < 0 {
                myDate.month += 1
                if myDate.month > 12 {
                    myDate.month = 1
                    myDate.year += 1
                }
                dayArray = calendarFunction.DayInArray(year: myDate.year, month: myDate.month)
            }

            if value.translation.width > 0 {
                myDate.month -= 1
                if myDate.month < 1 {
                    myDate.month = 12
                    myDate.year -= 1
                }
                dayArray = calendarFunction.DayInArray(year: myDate.year, month: myDate.month)
            }
        }))
    }
    
    func CheckCalendarInCoreData(day: Int) -> Bool {
        var output = false
        for game in games {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: game.wrappedTime)
            if components.day == day {
                output = true
                break
            }
        }
        return output
    }
}

struct AppCalendar_Previews: PreviewProvider {
    static var previews: some View {
        AppCalendar(startDate: Date() as NSDate, endDate: Date() as NSDate)
            .environmentObject(MyDate())
//            .environment(\.locale, .init(identifier: "zh-HK"))
    }
}

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
    @EnvironmentObject var appState: BaseViewModel
    @FetchRequest var games: FetchedResults<Game>
    @State var calendarFunction = CalendarFunction()
    
    let weekDays = [NSLocalizedString("Sun", comment: ""), NSLocalizedString("Mon", comment: ""), NSLocalizedString("Tue", comment: ""), NSLocalizedString("Wed", comment: ""), NSLocalizedString("Thu", comment: ""), NSLocalizedString("Fri", comment: ""), NSLocalizedString("Sat", comment: "")]
    @State var dayArray: [[Int]] = [[]]
    
    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date.now)
    
    @State var todayYear = 2022
    @State var todayMonth = 2
    @State var todayDay = 26
    
    init(startDate: NSDate, endDate: NSDate) {
        _games = FetchRequest<Game>(sortDescriptors: [], predicate: NSPredicate(format: "(time >= %@) AND (time <= %@)", startDate, endDate))
        components = Calendar.current.dateComponents([.year, .month, .day], from: Date.now)

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
                            Button {
                                appState.baseView = .setting
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(Font.system(.title2))
                                    .foregroundColor(buttonColor)
                            }
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
                    MonthCalenadar(dayArray: $dayArray, buttonSize: .constant(buttonSize), todayYear: $todayYear, todayMonth: $todayMonth, todayDay: $todayDay, games: .constant(games))
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
}

struct AppCalendar_Previews: PreviewProvider {
    static var previews: some View {
        AppCalendar(startDate: Date() as NSDate, endDate: Date() as NSDate)
            .environmentObject(MyDate())
            .environmentObject(BaseViewModel())
//            .environment(\.locale, .init(identifier: "zh-HK"))
    }
}

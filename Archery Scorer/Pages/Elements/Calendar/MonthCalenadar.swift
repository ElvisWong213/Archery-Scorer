//
//  MonthCalenadar.swift
//  Archery Scorer
//
//  Created by Elvis on 02/05/2023.
//

import SwiftUI

struct MonthCalenadar: View {
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let backgroundColor3 = Color("BackgroundColor3")
    let textColor = Color("TextColor")
    let buttonColor = Color("ButtonColor")
    
    @Binding var dayArray: [[Int]]
    @Binding var buttonSize: CGFloat
    @Binding var todayYear: Int
    @Binding var todayMonth: Int
    @Binding var todayDay: Int
    @Binding var games: FetchedResults<Game>
    
    @EnvironmentObject var myDate: MyDate
    
//    init(dayArray: Binding<[[Int]]>, buttonSize: Binding<CGFloat>, todayYear: Binding<Int>, todayMonth: Binding<Int>, todayDay: Binding<Int>, games: Binding<FetchedResults<Game>>) {
//        self.dayArray = dayArray
//        self.buttonSize = buttonSize
//        self.todayYear = todayYear
//        self.todayMonth = todayMonth
//        self.todayDay = todayDay
//        self.games = games
//    }
    
    var body: some View {
        ForEach(0..<dayArray.count, id: \.self) { weeks in
            HStack {
                ForEach(dayArray[weeks], id: \.self) { days in
                    Spacer()
                    Button {
                        myDate.day = days
                    } label: {
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

//struct MonthCalenadar_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthCalenadar(dayArray: .constant([[]]), buttonSize: .constant(UIScreen.main.bounds.width / 14), todayYear: .constant(2022), todayMonth: .constant(2), todayDay: .constant(6), games: .constant(FetchRequest<Game>(sortDescriptors: [], predicate: NSPredicate(format: "(time >= %@) AND (time <= %@)", Date() as NSDate, Date() as NSDate))))
//            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
//    }
//}

//
//  FilterBar.swift
//  Archery Scorer
//
//  Created by Elvis on 1/5/2022.
//

import SwiftUI
import CoreData

struct FilterBar: View {
    @State var filterBarFunction = FilterBarFunction()
    @State private var showDistance: [String] = []
    
    @EnvironmentObject var myDate: MyDate
    @Environment(\.managedObjectContext) var moc
    let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Game")
    
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    
    @State private var dateRange = ["Day", "Week", "Month", "Year"]
    @Binding var myRange: String
    
    @State var weekRange: [NSDate] = []
    @State var monthRange: [NSDate] = []
    @State var yearRange: [NSDate] = []
    
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date.now)
    @State var todayYear = 2022
    @State var todayMonth = 2
    @State var todayDay = 26
    
    let scoringMethodArray = ["6", "10"]
    @Binding var selectedScoringMethod: String
    @Binding var selectedDistance: String

    init(selectedScoringMethod: Binding<String>, selectedDistance: Binding<String>, selectedRange: Binding<String>) {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(buttonColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(textColor)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(buttonColor)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor.black
        self._selectedScoringMethod = selectedScoringMethod
        self._selectedDistance = selectedDistance
        self._myRange = selectedRange
        fetchRequest.propertiesToFetch = ["distance"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Distance: ")
                Menu {
                    Picker(selection: $selectedDistance, label: Text("Distance")) {
                        Text("All").tag("All")
                        if showDistance.isEmpty == false {
                            ForEach(showDistance, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                } label: {
                    Text(selectedDistance)
                        .font(.title2)
                        .foregroundColor(buttonColor)
                }
                Spacer()
                Text("Scoring Method: ")
                Menu {
                    Picker(selection: $selectedScoringMethod, label: Text("Scoring Method")) {
                        ForEach(scoringMethodArray, id: \.self) {
                            Text($0)
                        }
                    }
                } label: {
                    Text(selectedScoringMethod)
                        .font(.title2)
                        .foregroundColor(buttonColor)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Picker(selection: $myRange, label: Text("Date Picker")) {
                    ForEach(dateRange, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                Spacer()
            }
            ShowDateView(myRange: $myRange, todayYear: $todayYear, todayMonth: $todayMonth, todayDay: $todayDay, weekRange: $weekRange, monthRange: $monthRange, yearRange: $yearRange)
        }
        .background(backgroundColor2)
        .foregroundColor(textColor)
        .onAppear() {
            todayYear = components.year ?? 2022
            todayMonth = components.month ?? 2
            todayDay = components.day ?? 26
            
            myDate.selectedRange = filterBarFunction.FindTodayRange(year: todayYear, month: todayMonth, day: todayDay)
            weekRange = filterBarFunction.FindWeekRange(year: todayYear, month: todayMonth, day: todayDay)
            monthRange = filterBarFunction.FindMonthRange(year: todayYear, month: todayMonth)
            yearRange = filterBarFunction.FindYearRange(year: todayYear)
            
            let result = try! moc.fetch(fetchRequest)
            for i in result {
                for (_, value) in i {
                    showDistance.append(value as! String)
                }
            }
        }
    }
    
    
}

struct ShowDateView: View {
    let buttonColor = Color("ButtonColor")
    @EnvironmentObject var myDate: MyDate
    
    @State var filterBarFunction = FilterBarFunction()
    
    @Binding var myRange: String
    @Binding var todayYear: Int
    @Binding var todayMonth: Int
    @Binding var todayDay: Int
    @Binding var weekRange: [NSDate]
    @Binding var monthRange: [NSDate]
    @Binding var yearRange: [NSDate]
    
    var body: some View {
        HStack {
            Button {
                buttonChangeDate(next: false)
            }label: {
                Image(systemName: "backward.fill")
                    .foregroundColor(buttonColor)
            }
            .padding(.horizontal)
            Spacer()
            VStack {
                if myRange == "Day" {
                    Button {
                        myDate.selectedRange = filterBarFunction.FindTodayRange(year: todayYear, month: todayMonth, day: todayDay)
                    }label: {
                        Text(myDate.selectedRange[0].addingTimeInterval(600) as Date, style: .date)
                    }
                    .onAppear() {
                        myDate.selectedRange = filterBarFunction.FindTodayRange(year: todayYear, month: todayMonth, day: todayDay)
                    }
                }
                else if myRange == "Week" {
                    Button {
                        myDate.selectedRange = weekRange
                    }label: {
                        VStack {
                            Text(myDate.selectedRange[0].addingTimeInterval(600) as Date, style: .date)
                            Text("~")
                            Text(myDate.selectedRange[1].addingTimeInterval(600) as Date, style: .date)
                        }
                    }
                    .onAppear() {
                        myDate.selectedRange = weekRange
                    }
                }
                else if myRange == "Month" {
                    Button {
                        myDate.selectedRange = monthRange
                    }label: {
                        VStack {
                            Text(myDate.selectedRange[0].addingTimeInterval(600) as Date, style: .date)
                            Text("~")
                            Text(myDate.selectedRange[1].addingTimeInterval(600) as Date, style: .date)
                        }
                    }
                    .onAppear() {
                        myDate.selectedRange = monthRange
                    }
                }
                else if myRange == "Year" {
                    Button {
                        myDate.selectedRange = yearRange
                    }label: {
                        VStack {
                            Text(myDate.selectedRange[0].addingTimeInterval(600) as Date, style: .date)
                            Text("~")
                            Text(myDate.selectedRange[1].addingTimeInterval(600) as Date, style: .date)
                        }
                    }
                    .onAppear() {
                        myDate.selectedRange = yearRange
                    }
                }
            }
            .font(.headline)
            .foregroundColor(buttonColor)
            Spacer()
            Button {
                buttonChangeDate(next: true)
            }label: {
                Image(systemName: "forward.fill")
                    .foregroundColor(buttonColor)
            }
            .padding(.horizontal)
        }
    }
    
    func buttonChangeDate(next: Bool) {
        if myRange == "Day" {
            if next {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .day, value: 1, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .day, value: 1, to: myDate.selectedRange[1] as Date)! as NSDate
            } else {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .day, value: -1, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .day, value: -1, to: myDate.selectedRange[1] as Date)! as NSDate
            }
        }
        else if myRange == "Week" {
            if next {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .day, value: 7, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .day, value: 7, to: myDate.selectedRange[1] as Date)! as NSDate
            } else {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .day, value: -7, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .day, value: -7, to: myDate.selectedRange[1] as Date)! as NSDate
            }
        }
        else if myRange == "Month" {
            if next {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .month, value: 1, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .month, value: 1, to: myDate.selectedRange[1] as Date)! as NSDate
            } else {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .month, value: -1, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .month, value: -1, to: myDate.selectedRange[1] as Date)! as NSDate
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = Int(formatter.string(from: myDate.selectedRange[0] as Date)) ?? 2022
            formatter.dateFormat = "MM"
            let month = Int(formatter.string(from: myDate.selectedRange[0] as Date)) ?? 5
            myDate.selectedRange = filterBarFunction.FindMonthRange(year: year, month: month)
        }
        else if myRange == "Year" {
            if next {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .year, value: 1, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .year, value: 1, to: myDate.selectedRange[1] as Date)! as NSDate
            } else {
                myDate.selectedRange[0] = Calendar.current.date(byAdding: .year, value: -1, to: myDate.selectedRange[0] as Date)! as NSDate
                myDate.selectedRange[1] = Calendar.current.date(byAdding: .year, value: -1, to: myDate.selectedRange[1] as Date)! as NSDate
            }
        }
    }
}

struct FilterBar_Previews: PreviewProvider {
    static var previews: some View {
        FilterBar(selectedScoringMethod: .constant("6"), selectedDistance: .constant("All"), selectedRange: .constant("Day"))
            .environmentObject(MyDate())
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}

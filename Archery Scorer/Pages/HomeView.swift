//
//  HomeView.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI

struct HomeView: View {
    let backgroundColor = Color("BackgroundColor")
            
    @EnvironmentObject var myDate: MyDate

    var body: some View {
        VStack {
            AppCalendar(startDate: myDate.FindStartDate(), endDate: myDate.FindEndDate())
//                .frame(height: UIScreen.main.bounds.size.height * 0.35)
            ListOfRecord(startDate: myDate.FindStartDate(), endDate: myDate.FindEndDate())
                .frame(height: UIScreen.main.bounds.size.height * 0.45)
            BottomBar()
                .frame(height: UIScreen.main.bounds.size.height * 0.1)
        }
        .background(backgroundColor)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(CoreDataGameID())
            .environmentObject(StartData())
            .environmentObject(MyDate())
            .environmentObject(BaseViewModel())
    }
}

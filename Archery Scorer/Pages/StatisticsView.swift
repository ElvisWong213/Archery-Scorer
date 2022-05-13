//
//  StatisticsView.swift
//  Archery Scorer
//
//  Created by Steve on 30/3/2022.
//

import SwiftUI

struct StatisticsView: View {
    let backgroundColor2 = Color("BackgroundColor2")
    
    @EnvironmentObject var myDate: MyDate

    @State var selectedScoringMethod = "6"
    @State var selectedDistance = "All"
    @State var selectedRange = "Day"
    
    var body: some View {
        VStack {
            FilterBar(selectedScoringMethod: $selectedScoringMethod, selectedDistance: $selectedDistance, selectedRange: $selectedRange)
                .padding(.top)
            ChartCombine(startDate: myDate.selectedRange[0], endDate: myDate.selectedRange[1], scoringMethod: selectedScoringMethod, distance: selectedDistance, selectedRange: selectedRange)
            BottomBar()
                .frame(height: UIScreen.main.bounds.size.height * 0.1)
        }
        .background(backgroundColor2)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(BaseViewModel())
        
    }
}

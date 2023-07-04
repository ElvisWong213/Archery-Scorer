//
//  WeekCalendar.swift
//  Archery Scorer
//
//  Created by Elvis on 02/05/2023.
//

import SwiftUI

struct WeekCalendar: View {
    @Binding var buttonSize: CGFloat
    
    let backgroundColor2 = Color("BackgroundColor2")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    
    var body: some View {
        GeometryReader { gr in
            HStack {
                ForEach(0..<7, id: \.self) { i in
                    Spacer()
                    Button {
                        
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: buttonSize, height: buttonSize)
                                .foregroundColor(buttonColor)
                            Text("\(i+1)")
                                .foregroundColor(textColor)
                        }
                    }
                        .frame(width: buttonSize, height: buttonSize)
                    Spacer()
                }
            }
        }
    }
}

struct SmallCalendar_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendar(buttonSize: .constant(UIScreen.main.bounds.width / 14))
    }
}

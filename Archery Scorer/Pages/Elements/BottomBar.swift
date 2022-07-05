//
//  BottomBar.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI

struct BottomBar: View {
    
    let backgroundColor = Color("BackgroundColor")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    
    let buttonSize: CGFloat = UIScreen.main.bounds.size.height * 0.05
    let size = UIScreen.main.bounds.size.height * 0.08
    
    @EnvironmentObject var appState: BaseViewModel
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        appState.baseView = .home
                    }label: {
                        Image(systemName: "house")
                            .foregroundColor(appState.baseView == .home ? textColor : buttonColor)
                            .font(.system(size: buttonSize))
                    }
                    .accessibilityIdentifier("homeButton")
                    Spacer()
                    Button {
                        appState.baseView = .add
                    }label: {
                        ZStack(alignment: .center) {
                            Circle()
                                .frame(width: size, height: size)
                                .foregroundColor(buttonColor)
                            Image(systemName: "plus")
                                .foregroundColor(textColor)
                                .font(.system(size: buttonSize))
                        }
                    }
                    .accessibilityIdentifier("addButton")
                    Spacer()
                    Button {
                        appState.baseView = .statistic
                    }label: {
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundColor(appState.baseView == .statistic ? textColor : buttonColor)
                            .font(.system(size: buttonSize))
                    }
                    .accessibilityIdentifier("statisticButton")
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar()
            .environmentObject(BaseViewModel())
    }
}

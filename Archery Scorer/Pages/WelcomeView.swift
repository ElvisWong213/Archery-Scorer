//
//  WelcomeView.swift
//  Archery Scorer
//
//  Created by Elvis on 7/8/2022.
//

import SwiftUI

struct WelcomeView: View {
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    
    let buttonSize: CGFloat = UIScreen.main.bounds.size.height * 0.05
    let size = UIScreen.main.bounds.size.height * 0.08
    
    @State var pages = 1
    @Binding var wellcome: Bool
    
    private let data = [
        ["icon" : "hand.tap", "title" : "Tap", "body" : "Tap to mark your score and position."],
        ["icon" : "chart.xyaxis.line", "title" : "Analyze", "body" : "Analyze your score with chart."],
        ["icon" : "square.and.arrow.up", "title" : "Share", "body" : "Share your score to social media and more."],
        ["icon" : "icloud.and.arrow.up", "title" : "Sync", "body" : "Sync your data on iPad and iPhone."],
        ["icon" : "ellipsis", "title" : "More", "body" : "More and more features."]
    ]

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                if pages == 1 {
                    Spacer()
                }
                VStack {
                    Text("Wellcome to")
                        .foregroundColor(textColor)
                        .font(.title)
                    Text("Archery Marker")
                        .foregroundColor(backgroundColor2)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                }
                .padding()
                .multilineTextAlignment(.center)
                .animation(.default, value: pages)
                if pages == 1 {
                    Image("Icon")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.5)
                        .shadow(color: Color.white, radius: 10, x: 0, y: 0)
                        .padding(.vertical, 60)
                        .transition(.opacity)

                }
                if pages == 2 {
                    ForEach(data, id: \.self) { i in
                        HStack {
                            Image(systemName: i["icon"]!)
                                .font(.system(size: 50))
                                .frame(width: 50, height: 50)
                                .foregroundColor(buttonColor)
                                .padding(.horizontal)
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey(i["title"]!))
                                    .font(.title)
                                Text(LocalizedStringKey(i["body"]!))
                            }
                            .foregroundColor(textColor)
                            Spacer()
                        }
                        .padding()
                        .transition(.asymmetric(insertion: .slide, removal: .opacity))
                    }
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        if pages < 2 {
                            pages += 1
                        } else {
//                            pages = 1
                            wellcome = false
                        }
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: pages == 1 ? 75 : 30)
                            .frame(width: pages == 1 ? size : size * 3, height: size)
                            .foregroundColor(buttonColor)
                        HStack {
                            if pages == 2 {
                                Text("Start")
                                    .font(.title)
                                    .foregroundColor(textColor)
                                    .transition(.scale)
                            }
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .foregroundColor(textColor)
                        }
                    }
                }
                .padding()
            }
        }
//        .onAppear() {
//            withAnimation {
//                pages += 1
//            }
//        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(wellcome: .constant(true))
    }
}

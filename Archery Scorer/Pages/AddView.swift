//
//  AddView.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI

struct AddView: View {
    
    let backgroundColor = Color("BackgroundColor")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    
    @EnvironmentObject var startData: StartData
    @EnvironmentObject var appState: BaseViewModel
    @State var now = Date.now
    @State var distance = ""
    @State var scoringMethod = "6"
    @State var showAlert = false
    
    let scoringMethodArray = ["6", "10"]
        
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        appState.baseView = .home
                    } label: {
                        Text("Back")
                    }
                    .padding()
                    .foregroundColor(buttonColor)
                    Spacer()
                }
                Spacer()
                HStack {
                    DatePicker(selection: $now, label: {Text("Start Time: ")})
                        .fixedSize()
                }
                .padding()
                HStack {
                    Text("Distance: ")
                    TextField("10", text: $distance)
                        .fixedSize()
                        .keyboardType(.numberPad)
                        .font(.title2)
                        .accessibilityIdentifier("distance")
                    Text("m")
                }
                .padding()
                HStack {
                    Text("Scoring Method: ")
                    Menu {
                        Picker(selection: $scoringMethod, label: Text("Scoring Method")) {
                            ForEach(scoringMethodArray, id: \.self) {
                                Text($0)
                            }
                        }
                    } label: {
                        Text(scoringMethod)
                            .font(.title2)
                            .foregroundColor(buttonColor)
                    }
                    .frame(width: 40)
                    Text("Zone")
                }
                .padding()
                Spacer()
                Button {
                    if checkDataValid() {
                        startData.time = now
                        startData.distance = distance
                        startData.scoringMethod = scoringMethod
                        appState.baseView = .record
                    }else{
                        showAlert.toggle()
                    }
                } label: {
                    Text("Start")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 150)
                        .background(buttonColor)
                }
                .alert("Please input all the data!", isPresented: $showAlert, actions: {
                    Button("OK") {
                    }
                })
                .cornerRadius(15)
                Spacer()
            }
            .foregroundColor(textColor)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .preferredColorScheme(.dark)
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func checkDataValid() -> Bool {
        if distance != "" {
            return true
        }else{
            return false
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
//            .environment(\.locale, .init(identifier: "zh-HK"))
    }
}

//
//  ExportPopUp.swift
//  Archery Scorer
//
//  Created by Elvis on 10/7/2022.
//

import SwiftUI

struct ExportPopUp: View {
    var textColor = Color("TextColor")
    var backgroundColor = Color("BackgroundColor")
    var backgroundColor2 = Color("BackgroundColor2")
    var buttonColor = Color("ButtonColor")
    
    @EnvironmentObject var startData: StartData
    @EnvironmentObject var coreDataGameID: CoreDataGameID
    
    @State var selectedBox = [0, 0]
    @State var selectedRowButton = false
    var rowItems = ["CSV", "Image"]
    @State var selectCSV = false
    @State var selectImage = false
    let cornerRad: CGFloat = 15
    
    @Binding var showPopUp: Bool
    @Binding var myImage: UIImage

    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("CSV")
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(.title))
                        .foregroundColor(buttonColor)
                }
                .listRowBackground(backgroundColor2)
                .padding()
                .foregroundColor(textColor)
                .background(backgroundColor)
                .cornerRadius(15)
                .onTapGesture {
                    selectCSV = true
                }
                .sheet(isPresented: $selectCSV) {
                    let myCSV = shareCSV()
                    ActivityView(activityItems: [myCSV], applicationActivities: nil)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Image")
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(.title))
                        .foregroundColor(buttonColor)
                }
                .listRowBackground(backgroundColor2)
                .padding()
                .foregroundColor(textColor)
                .background(backgroundColor)
                .cornerRadius(15)
                .onTapGesture {
                    selectImage = true
                }
                .sheet(isPresented: $selectImage) {
                    ActivityView(activityItems: [myImage], applicationActivities: nil)
                }
            }
            .onChange(of: selectImage) { _ in
                if selectImage == false {
                    showPopUp = false
                }
            }
            .onChange(of: selectCSV) { _ in
                if selectCSV == false {
                    showPopUp = false
                }
            }
            .background(backgroundColor2)
            .listStyle(.plain)
            .navigationTitle("Export Format")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showPopUp = false
                    }
                    .foregroundColor(buttonColor)
                }
            }
        }
    }
    
    func shareCSV() -> URL {
        let dataDate = startData.time
        let formatter = DateFormatter()
        formatter.dateFormat = "d-M-y"
        let fileName = "ArcheryMaker_\(formatter.string(from: dataDate)).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Round,1,2,3,4,5,6,6S\n"
        var round = 1
        var counter = 1
        var sixScore = 0
        var total = 0
        let rawData = coreDataGameID.scoreData
        let scoreData = ScoreDataFunction().FlatScoreData(scoreData: rawData)
        
        for score in scoreData {
            if counter == 1 {
                csvText += "\(round),"
            }
            csvText += "\(score),"
            if score == "X" {
                sixScore += 10
            }
            else if score == "M" {
                sixScore += 0
            }
            else {
                sixScore += Int(score) ?? 0
            }
            counter += 1
            if counter % 7 == 0 {
                csvText += "\(sixScore)\n"
                total += sixScore
                sixScore = 0
                counter = 1
                round += 1
            }
        }
        
        csvText += "Total, , , , , , ,\(total)\n"
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        return path!
    }
}

struct ExportPopUp_Previews: PreviewProvider {
    static var previews: some View {
        ExportPopUp(showPopUp: .constant(false), myImage: .constant(UIImage()))
    }
}

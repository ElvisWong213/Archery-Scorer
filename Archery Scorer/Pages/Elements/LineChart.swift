//
//  LineChart.swift
//  Archery Scorer
//
//  Created by Steve on 25/3/2022.
//

import SwiftUI

struct LineChart: View {
    @Binding var score: [Double]
    @Binding var circleSize: CGFloat
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    @Binding var xAxis: [String]
    var body: some View {
        GeometryReader { gr in
            let points = findPosition(score: score, height: gr.size.height * 0.8, width: gr.size.width)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ZStack {
                        Path { path in
                            for point in points {
                                if path.isEmpty {
                                    path.move(to: point)
                                } else {
                                    path.addLine(to: point)
                                }
                            }
                        }
                        .stroke(Color(white: 0.7), lineWidth: lineWidth)
                        ForEach (0..<score.count, id: \.self) { i in
                            let x = points[i].x
                            let y = points[i].y
                            Circle().path(in: CGRect(x: x - circleSize / 2, y: y - circleSize / 2, width: circleSize, height: circleSize))
                            Text("\(score[i], specifier: "%.2f")")
                                .fontWeight(.bold)
                                .font(.footnote)
                                .position(x: x, y: y - 20)
                            if xAxis.count == 0 {
                                Text(String(i + 1))
                                    .fontWeight(.bold)
                                    .position(x: x, y: gr.size.height * 0.9)
                            } else {
                                Text(String(xAxis[i]))
                                    .fontWeight(.bold)
                                    .position(x: x, y: gr.size.height * 0.9)
                            }
                        }
                    }
                    .foregroundColor(color)
                    .padding([.top, .leading, .trailing])
                }
                .frame(width: gr.size.width * windowWidth(score: score), height: gr.size.height)
            }
        }
    }
    func windowWidth(score: [Double]) -> CGFloat {
        if score.count > 6 {
            return CGFloat(score.count) / 7
        }
        return 1
    }
    
    func findPosition(score: [Double], height: CGFloat, width: CGFloat) -> [CGPoint] {
        var output: [CGPoint] = []
        var eachPointDistance = Double(width) / (Double(score.count))
        if score.count == 1 {
            eachPointDistance = Double(width) / 2
        }
        if score.count > 6 {
            eachPointDistance = Double(width) / 7
        }
        var maxScore = 0.0
        for i in score {
            if i > maxScore {
                maxScore = i
            }
        }
        
        for i in 0..<score.count {
            var x = CGFloat(Double(i) * eachPointDistance)
            if score.count == 1 {
                x = CGFloat(eachPointDistance)
            }
            var y: CGFloat = height
            if score[i] == 0 {
                y = height
            }else{
                y = (maxScore - score[i]) / maxScore * height + 10
            }
            let point = CGPoint(x: x, y: y)
            output.append(point)
        }
        return output
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(score: .constant([10, 9, 8, 7, 6, 5]), circleSize: .constant(10), color: .constant(.blue), lineWidth: .constant(2), xAxis: .constant([]))
//            .frame(width: 200, height: 200)
    }
}

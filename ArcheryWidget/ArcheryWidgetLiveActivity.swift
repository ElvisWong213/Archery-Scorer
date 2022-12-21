//
//  ArcheryWidgetLiveActivity.swift
//  ArcheryWidget
//
//  Created by Elvis on 16/12/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ArcheryWidgetAttributes: ActivityAttributes {
    public typealias ArcheryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var total: Int
        var average: Double
        var round: Int
        var shots: Int
    }

    // Fixed non-changing properties about your activity go here!
}

@available(iOS 16.1, *)
struct ArcheryWidgetLiveActivity: Widget {
    let backgroundColor = Color("BackgroundColor")
    let textColor = Color("TextColor")
    let buttonColor = Color("ButtonColor")
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ArcheryWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                HStack{
                    VStack {
                        Text("Average")
                        Text("\(context.state.average, specifier: "%.2f")")
                            .font(.largeTitle)
                            .foregroundColor(buttonColor)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    VStack {
                        Text("Round")
                        Text("\(context.state.round)")
                            .font(.title)
                            .foregroundColor(buttonColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    VStack{
                        Text("Total Score")
                        Text("\(context.state.total)")
                            .font(.largeTitle)
                            .foregroundColor(buttonColor)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Spacer()
                Grid(horizontalSpacing: 20) {
                    GridRow {
                        ForEach(1..<7) { index in
                            if index == context.state.shots + 1 {
                                Text("🏹")
                            } else {
                                Text(" ")
                            }
                        }
                    }
                    GridRow {
                        ForEach(1..<7) { index in
                            Circle()
                                .fill(index <= context.state.shots ? buttonColor : textColor)
                        }
                    }
                }
            }
            .padding(.vertical)
            .foregroundColor(textColor)
            .activityBackgroundTint(backgroundColor)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Text("Average")
                        Text("\(context.state.average, specifier: "%.2f")")
                            .font(.largeTitle)
                            .foregroundColor(buttonColor)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack{
                        Text("Total Score")
                        Text("\(context.state.total)")
                            .font(.largeTitle)
                            .foregroundColor(buttonColor)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        Text("Round")
                        Text("\(context.state.round)")
                            .font(.title)
                            .foregroundColor(buttonColor)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Grid(horizontalSpacing: 20) {
                        GridRow {
                            ForEach(1..<7) { index in
                                if index == context.state.shots + 1 {
                                    Text("🏹")
                                } else {
                                    Text(" ")
                                }
                            }
                        }
                        GridRow {
                            ForEach(1..<7) { index in
                                Circle()
                                    .fill(index <= context.state.shots ? buttonColor : textColor)
                            }
                        }
                    }
                }
            } compactLeading: {
                Text("\(context.state.average, specifier: "%.2f")")
                    .foregroundColor(buttonColor)
            } compactTrailing: {
                Text("\(context.state.total)")
                    .foregroundColor(buttonColor)
            } minimal: {
                Text("R: \(context.state.round)")
                    .foregroundColor(buttonColor)
            }
            .keylineTint(buttonColor)
        }
    }
}

@available(iOS 16.2, *)
struct ArcheryWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = ArcheryWidgetAttributes()
    static let contentState = ArcheryWidgetAttributes.ContentState(total: 100, average: 10, round: 5, shots: 3)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

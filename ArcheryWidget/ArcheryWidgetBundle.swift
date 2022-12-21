//
//  ArcheryWidgetBundle.swift
//  ArcheryWidget
//
//  Created by Elvis on 16/12/2022.
//

import WidgetKit
import SwiftUI

@main
struct ArcheryWidgetBundle: WidgetBundle {
    var body: some Widget {
        ArcheryWidget()
        if #available(iOS 16.1, *) {
            ArcheryWidgetLiveActivity()
        }
    }
}

//
//  GlypheWidgetBundle.swift
//  GlypheWidget
//
//  Created by Duncan Gough on 23/11/2023.
//

import WidgetKit
import SwiftUI

@main
struct GlypheWidgetBundle: WidgetBundle {
    var body: some Widget {
        GlypheWidget()
        //GlypheWidgetLiveActivity()
    }
}

// Widget and Provider Registration
struct GlypheWidget: Widget {
    let kind: String = "Hieroscope Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RandomIconsProvider()) { entry in
            RandomIconsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Hieroscope")
        .description("Thee Hieroscope")
    }
}



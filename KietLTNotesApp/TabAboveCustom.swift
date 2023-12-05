//
//  TabAboveCustom.swift
//  KietLTNotesApp
//
//  Created by Lê Kiệt on 12/5/23.
//

import Foundation
import SwiftUI

struct TabAboveCustom<Label: View>: View {
    @Binding var tabs: [String] // The tab titles
    @Binding var selection: String // Currently selected tab
    let underlineColor: Color // Color of the underline of the selected tab
    // Tab label rendering closure - provides the current title and if it's the currently selected tab
    let label: (String, Bool) -> Label // Label of tab
    let callback: (() -> ())? // Call back function when selected tab
    @State private var scrollViewContentSize: CGSize = .zero
    
    var body: some View {
        // Pack the tabs horizontally and allow them to be scrolled
            HStack(alignment: .center, spacing: 10) {
                ForEach(tabs, id: \.self) {
                    self.renderTab(title: $0)
                }
            }.background(
                GeometryReader { geo -> Color in
                    DispatchQueue.main.async {
                        scrollViewContentSize = geo.size
                    }
                    return Color.clear
                }
            )
        }

    
    /// Render tab
    private func renderTab(title: String) -> some View {
        let index = tabs.firstIndex(of: title)
        let isSelected = title == selection
        return Button(action: {
            self.selection = title
            if let callback = callback {
                callback()
            }
        }) {
            VStack(alignment: .leading) {
                label(title, isSelected)
            }
        }
    }
}


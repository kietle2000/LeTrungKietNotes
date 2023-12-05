//
//  ViewDidLoadModifier.swift
//  KietLTNotesApp
//
//  Created by Lê Kiệt on 12/5/23.
//

import Foundation
import SwiftUI
import Combine

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false // Did load
    private let action: (() -> Void)? // Action call

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

extension View {
    /// On load
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
    func modalAddName(isShow: Binding<Bool>,name: Binding<String>) -> some View {
        self.modifier(PopUpAddName(show: isShow,name: name))
    }
}

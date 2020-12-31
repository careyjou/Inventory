//
//  SheetView.swift
//  Inventory
//
//  Created by Vincent Spitale on 11/27/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

protocol SheetView: View {
    
    func content() -> AnyView
    func options() -> AnyView
    func sheetContent() -> AnyView
    
}

extension SheetView {
    func combined() -> some View {
        ContentSheet<AnyView>(sheetContent: sheetContent())
        }
    
}


fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 5
    static let indicatorWidth: CGFloat = 35
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.15
}

struct ContentSheet<Content: View>: View {
    let sheetContent: Content
    @State var isOpen: Bool = false
    
    var body: some View {
            BottomSheetView(isOpen: $isOpen, maxHeight: 800) {
                sheetContent
            }.edgesIgnoringSafeArea(.bottom)
        }
    
    
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
            self.isOpen.toggle()
        }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Blur())
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

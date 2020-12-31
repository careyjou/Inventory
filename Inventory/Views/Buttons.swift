//
//  Buttons.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/10/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ButtonMaterial: View {
    
    var highContrast: Bool
    
    var body: some View {
        return self.material()
    }
    
    @ViewBuilder func material() -> some View {
        if self.highContrast {
            Color.primary
        }
        else {
            Blur(style: .systemUltraThinMaterial)
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


public struct CircleButton: ButtonStyle {
    
    @State var highContrast: Bool = false
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.system(.title).bold())
            //.shadow(radius: 3.0)
            .foregroundColor(.primary)
            .padding()
            .frame(minWidth: 55, maxWidth: 55, minHeight: 55, maxHeight: 55)
            .background(Blur())
            .contentShape(Circle())
            .clipShape(Circle())
            //.hoverEffect(.lift)
            .compositingGroup()
            
            .padding()
            
            //.shadow(radius: 3.0)
            .opacity(configuration.isPressed ? 0.2 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.85: 1)
    }
}



public struct SecondaryCircleButton: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.system(.subheadline).bold())
            
            //.shadow(radius: 3.0)
            .padding(10)
            .foregroundColor(.primary)
            
            
            .background(Blur(style: .systemUltraThinMaterial))
            .contentShape(Circle())
            .clipShape(Circle())
            //.hoverEffect(.lift)
            .compositingGroup()
            //.shadow(radius: 3.0)
            .opacity(configuration.isPressed ? 0.2 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.85: 1)
    }
}




public struct RoundedButton: ButtonStyle {
    @State var textColor: Color = .secondary
    @State var cornerRadius: CGFloat = 0
    @State var highContrast: Bool = false
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        ZStack{
        configuration.label
            .font(Font.system(.subheadline).bold())
            .padding(10)
            .foregroundColor(highContrast ? Color(.systemBackground) : textColor)
            
            
            .background(ButtonMaterial(highContrast: highContrast))
            .contentShape(RoundedRectangle(cornerRadius: (cornerRadius != 0) ? cornerRadius: .greatestFiniteMagnitude))
            .clipShape(RoundedRectangle(cornerRadius: (cornerRadius != 0) ? cornerRadius: .greatestFiniteMagnitude))
            //.hoverEffect(.lift)
            .compositingGroup()
            //.shadow(radius: 3.0)
            .opacity(configuration.isPressed ? 0.2 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.85: 1)
        }
    }
}





public struct NavigationButton: ButtonStyle {
    @State var backgroundColor: Color = Color(.clear)
    @State var isRounded: Bool = true
    @State var isPadded: Bool = true
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        HStack{
            configuration.label
                .padding(.horizontal, 10)
            Spacer()
        }
        .contentShape(Rectangle())
        .frame(maxWidth: 700)
        .padding(.vertical, isPadded ? 12: 0)
        .background(configuration.isPressed ? Color("customFill").opacity(0.9): backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: isRounded ? 10.0: 0))
    }
}





public struct LargeTransparentRoundedButton: ButtonStyle {
    @State var isSelected: Bool
    @State var textColor: Color = .secondary
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.system(.headline))
            .padding()
            .foregroundColor(self.isSelected ? Color.primary: textColor)
            
            
            .background(Blur(style: .systemUltraThinMaterial))
            .contentShape(RoundedRectangle(cornerRadius: .greatestFiniteMagnitude))
            .clipShape(RoundedRectangle(cornerRadius: .greatestFiniteMagnitude))
            //.hoverEffect(.lift)
            .compositingGroup()
            //.shadow(radius: 3.0)
            .opacity(configuration.isPressed ? 0.2 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.85: 1)
    }
}

public struct SimpleScalingButton: ButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .scaleEffect(configuration.isPressed ? 0.85: 1)
    }
}


public struct ScalingOpacityButton: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85: 1)
            .opacity(configuration.isPressed ? 0.2 : 1.0)
    }
    
}



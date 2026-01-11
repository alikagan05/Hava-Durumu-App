//
//  View+Ext.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import SwiftUI

struct Glassmorphism: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

extension View {
    func glass(cornerRadius: CGFloat = 15) -> some View {
        self.modifier(Glassmorphism(cornerRadius: cornerRadius))
    }
}

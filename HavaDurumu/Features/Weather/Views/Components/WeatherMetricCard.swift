//
//  WeatherMetricCard.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import SwiftUI

struct WeatherMetricCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .glass(cornerRadius: 12)
    }
}

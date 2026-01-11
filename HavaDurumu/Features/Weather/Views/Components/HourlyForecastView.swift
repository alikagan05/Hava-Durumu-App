//
//  HourlyForecastView.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import SwiftUI

struct HourlyForecastView: View {
    let hours: [Hour]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SAATLİK TAHMİN")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.7))
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(hours) { hour in
                        VStack(spacing: 10) {
                            Text(extractHour(from: hour.time))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView().tint(.white)
                            }
                            .frame(width: 30, height: 30)
                            
                            Text("\(Int(hour.temp_c))°")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .glass(cornerRadius: 16)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
    }
    
    private func extractHour(from time: String) -> String {
        // "2023-10-01 14:00" -> "14:00"
        let split = time.split(separator: " ")
        if split.count > 1 {
            return String(split[1])
        }
        return time
    }
}

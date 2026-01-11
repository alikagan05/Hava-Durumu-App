//
//  DailyForecastView.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import SwiftUI

struct DailyForecastView: View {
    let days: [ForecastDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("GÜNLÜK TAHMİN")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(days) { day in
                    HStack {
                        Text(dayName(from: day.date))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 100, alignment: .leading)
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: "https:\(day.day.condition.icon)")) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView().tint(.white)
                        }
                        .frame(width: 30, height: 30)
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Text("\(Int(day.day.mintemp_c))°")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.7))
                            Text("-")
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(Int(day.day.maxtemp_c))°")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, alignment: .trailing)
                    }
                    .padding()
                    .glass(cornerRadius: 12)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func dayName(from dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateStr) {
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "tr_TR")
            return formatter.string(from: date).capitalized
        }
        return dateStr
    }
}

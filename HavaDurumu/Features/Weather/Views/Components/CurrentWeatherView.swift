//
//  CurrentWeatherView.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import SwiftUI

struct CurrentWeatherView: View {
    let weather: WeatherResponse
    
    var body: some View {
        VStack(spacing: 5) {
            // Şehir Adı
            Text(weather.location.name)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            // Sıcaklık
            Text("\(Int(weather.current.temp_c))°")
                .font(.system(size: 96, weight: .thin, design: .rounded))
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            // Durum
            HStack {
                AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView().tint(.white)
                }
                .frame(width: 40, height: 40)
                
                Text(weather.current.condition.text)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.bottom, 20)
            
            // Grid Detayları
            HStack(spacing: 20) {
                WeatherMetricCard(icon: "humidity", title: "Nem", value: "%\(weather.current.humidity)")
                WeatherMetricCard(icon: "wind", title: "Rüzgar", value: "\(Int(weather.current.wind_kph)) km/s")
                WeatherMetricCard(icon: "thermometer", title: "Hissedilen", value: "\(Int(weather.current.feelslike_c))°")
            }
        }
        .padding()
    }
}

//
//  WeatherModel.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import Foundation

// Main Response Model
struct WeatherResponse: Codable, Sendable {
    let location: Location
    let current: Current
    let forecast: Forecast?
}

struct Location: Codable, Sendable {
    let name: String
    let lat: Double
    let lon: Double
}

struct Current: Codable, Sendable {
    let temp_c: Double
    let condition: Condition
    let humidity: Int
    let wind_kph: Double
    let feelslike_c: Double
    let is_day: Int
}

struct Condition: Codable, Sendable {
    let text: String
    let icon: String // "//cdn.weatherapi.com..."
}

// MARK: - Forecast Models

struct Forecast: Codable, Sendable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable, Sendable {
    var id: String { date }
    let date: String
    let day: Day
    let hour: [Hour]
}

struct Day: Codable, Sendable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let avgtemp_c: Double
    let condition: Condition
}

struct Hour: Codable, Identifiable, Sendable {
    var id: String { time }
    let time: String // "2023-12-30 14:00"
    let temp_c: Double
    let condition: Condition
    let is_day: Int
}

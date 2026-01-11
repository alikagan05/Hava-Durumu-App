//
//  MockWeatherService.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import Foundation

class MockWeatherService: WeatherServiceProtocol {
    var shouldFail = false
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        try await mockResponse()
    }
    
    func fetchLocalWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        try await mockResponse()
    }
    
    private func mockResponse() async throws -> WeatherResponse {
        if shouldFail {
            throw WeatherError.serverError
        }
        
        // Simulating network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return WeatherResponse(
            location: Location(name: "Test City", lat: 41.0, lon: 29.0),
            current: Current(
                temp_c: 20.0,
                condition: Condition(text: "Parçalı Bulutlu", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"),
                humidity: 50,
                wind_kph: 10.0,
                feelslike_c: 19.0,
                is_day: 1
            ),
            forecast: Forecast(forecastday: [
                ForecastDay(
                    date: "2023-12-30",
                    day: Day(
                        maxtemp_c: 22.0,
                        mintemp_c: 15.0,
                        avgtemp_c: 18.0,
                        condition: Condition(text: "Güneşli", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png")
                    ),
                    hour: [
                        Hour(time: "2023-12-30 00:00", temp_c: 15.0, condition: Condition(text: "Açık", icon: ""), is_day: 0),
                        Hour(time: "2023-12-30 12:00", temp_c: 22.0, condition: Condition(text: "Güneşli", icon: ""), is_day: 1)
                    ]
                )
            ])
        )
    }
}

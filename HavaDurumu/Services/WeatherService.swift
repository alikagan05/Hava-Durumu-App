//
//  WeatherService.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResponse
    func fetchLocalWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse
}

enum WeatherError: Error {
    case invalidURL
    case noData
    case decodingError
    case cityNotFound
    case serverError
    case unknown(Error)
}

class WeatherService: WeatherServiceProtocol {
    
    // forecast.json includes both current and forecast data.
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let urlString = "\(Constants.API.baseURL)/forecast.json?key=\(Constants.API.key)&q=\(query)&days=3&aqi=no&alerts=no&lang=tr"
        
        return try await performRequest(urlString: urlString)
    }
    
    func fetchLocalWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let query = "\(latitude),\(longitude)"
        let urlString = "\(Constants.API.baseURL)/forecast.json?key=\(Constants.API.key)&q=\(query)&days=3&aqi=no&alerts=no&lang=tr"
        
        return try await performRequest(urlString: urlString)
    }
    
    private func performRequest(urlString: String) async throws -> WeatherResponse {
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        print("🌍 Fetching: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.serverError
        }
        
        switch httpResponse.statusCode {
        case 200:
            do {
                let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                return decodedResponse
            } catch {
                print("❌ Decoding Error: \(error)")
                throw WeatherError.decodingError
            }
        case 400, 404:
            throw WeatherError.cityNotFound
        default:
            throw WeatherError.serverError
        }
    }
}

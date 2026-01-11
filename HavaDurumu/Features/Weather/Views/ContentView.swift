//
//  ContentView.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            // Dynamic Background
            LinearGradient(gradient: Gradient(colors: getBackgroundColors()),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isSearchFocused = false
                }
            
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                    .padding(.horizontal)
                    .padding(.top, 50)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Spacer()
                } else if let weather = viewModel.weather {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            CurrentWeatherView(weather: weather)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            
                            // Hourly forecast for the current day
                            if let hours = weather.forecast?.forecastday.first?.hour {
                                // Show hours from now onwards
                                let currentHour = Calendar.current.component(.hour, from: Date())
                                let futureHours = hours.filter {
                                    let hourString = $0.time.split(separator: " ").last ?? "" // "14:00"
                                    let hourInt = Int(hourString.split(separator: ":").first ?? "") ?? 0
                                    return hourInt >= currentHour
                                }
                                HourlyForecastView(hours: futureHours)
                            }
                            
                            if let days = weather.forecast?.forecastday {
                                DailyForecastView(days: days)
                            }
                            
                            Spacer().frame(height: 50)
                        }
                        .padding(.top)
                    }
                    .refreshable {
                        if !viewModel.searchText.isEmpty {
                            viewModel.getWeather(city: viewModel.searchText)
                        } else {
                            viewModel.requestLocation()
                        }
                    }
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 15) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        Text(error)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Button("Tekrar Dene") {
                            viewModel.requestLocation()
                        }
                        .padding()
                        .background(.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    .padding()
                    Spacer()
                } else {
                    // Initial State (Waiting for location or permission)
                    Spacer()
                    VStack {
                        Image(systemName: "location.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.7))
                        Text("Konum alınıyor...")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                    Spacer()
                }
            }
            
            if !viewModel.filteredCities.isEmpty && isSearchFocused {
                searchSuggestions
            }
        }
        .onAppear {
            viewModel.requestLocation()
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.6))
            
            TextField("Şehir Ara...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .focused($isSearchFocused)
                .onSubmit {
                    viewModel.getWeather(city: viewModel.searchText)
                    isSearchFocused = false
                }
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
    
    var searchSuggestions: some View {
        VStack {
            ForEach(viewModel.filteredCities.prefix(5), id: \.self) { city in
                Button {
                    viewModel.searchText = city
                    viewModel.getWeather(city: city)
                    isSearchFocused = false
                } label: {
                    HStack {
                        Text(city)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                }
                Divider()
            }
        }
        .background(.regularMaterial)
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.top, 120) // Position below search bar
        .frame(maxHeight: .infinity, alignment: .top)
        .shadow(radius: 10)
    }
    
    func getBackgroundColors() -> [Color] {
        if let weather = viewModel.weather {
            let config = weather.current
            // Simple logic: Day or Night?
            if config.is_day == 0 {
                // Night
                return [Color(hex: "0f2027"), Color(hex: "203a43"), Color(hex: "2c5364")]
            } else {
                // Day
                if config.condition.text.lowercased().contains("yağmur") || config.condition.text.lowercased().contains("bulut") {
                   return [Color(hex: "bdc3c7"), Color(hex: "2c3e50")] // Overcast/Rainy
                }
                return [Color(hex: "2980b9"), Color(hex: "6dd5fa"), Color(hex: "ffffff")] // Clear/Sunny
            }
        }
        return [Constants.Colors.weatherBackground1, Constants.Colors.weatherBackground2]
    }
}

#Preview {
    ContentView()
}

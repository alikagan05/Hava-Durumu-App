//
//  WeatherViewModel.swift
//  HavaDurumu
//
//  Created by ali kağan on 30.12.2025.
//

import Foundation
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var isLoading = false
    
    // Location Manager
    @Published var locationManager = LocationManager()
    
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // City List (Static list for demo)
    private let allCities = [
        "Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Amasya", "Ankara", "Antalya", "Artvin", "Aydın", "Balıkesir",
        "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum", "Denizli",
        "Diyarbakır", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkari",
        "Hatay", "Isparta", "Mersin", "İstanbul", "İzmir", "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir",
        "Kocaeli", "Konya", "Kütahya", "Malatya", "Manisa", "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir",
        "Niğde", "Ordu", "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Tekirdağ", "Tokat",
        "Trabzon", "Tunceli", "Şanlıurfa", "Uşak", "Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt", "Karaman",
        "Kırıkkale", "Batman", "Şırnak", "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"
    ]
    
    var filteredCities: [String] {
        if searchText.isEmpty {
            return []
        } else {
            let locale = Locale(identifier: "tr_TR")
            return allCities.filter { $0.lowercased(with: locale).contains(searchText.lowercased(with: locale)) }
        }
    }
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = service
        subscribeToLocation()
    }
    
    private func subscribeToLocation() {
        // Did receive location
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.getWeatherByLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
            .store(in: &cancellables)
            
        // Permission denied
        locationManager.$permissionDenied
            .sink { [weak self] denied in
                if denied {
                    self?.isLoading = false
                    self?.errorMessage = "Konum izni verilmedi. Lütfen şehir arayın."
                }
            }
            .store(in: &cancellables)
    }
    
    func requestLocation() {
        isLoading = true
        locationManager.requestLocation()
    }
    
    func getWeather(city: String) {
        guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                weather = try await weatherService.fetchWeather(for: city)
            } catch {
                handleError(error)
            }
            
            isLoading = false
        }
    }
    
    func getWeatherByLocation(lat: Double, lon: Double) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                weather = try await weatherService.fetchLocalWeather(latitude: lat, longitude: lon)
            } catch {
                handleError(error)
            }
            isLoading = false
        }
    }
    
    private func handleError(_ error: Error) {
        if let weatherError = error as? WeatherError {
            switch weatherError {
            case .cityNotFound:
                errorMessage = "Şehir bulunamadı."
            case .serverError:
                errorMessage = "Sunucu hatası veya bağlantı sorunu."
            case .decodingError:
                errorMessage = "Veri işleme hatası."
            case .invalidURL:
                errorMessage = "Geçersiz istek."
            case .noData:
                errorMessage = "Veri alınamadı."
            case .unknown(let err):
                errorMessage = "Hata: \(err.localizedDescription)"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
}

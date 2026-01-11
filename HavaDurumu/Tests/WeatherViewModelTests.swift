//
//  WeatherViewModelTests.swift
//  HavaDurumuTests
//
//  Created by ali kağan on 30.12.2025.
//

#if canImport(XCTest)
import XCTest
@testable import HavaDurumu

@MainActor
final class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
         super.tearDown()
     }
     
     func testGetWeatherSuccess() async {
         // Given
         mockService.shouldFail = false
         
         // When
         viewModel.getWeather(city: "Test")
         
         // Task'ın tamamlanmasını bekle
         try? await Task.sleep(nanoseconds: 1_000_000_000)
         
         // Then
         XCTAssertNotNil(viewModel.weather)
         XCTAssertEqual(viewModel.weather?.location.name, "Test City")
         XCTAssertNil(viewModel.errorMessage)
     }
     
     func testGetWeatherFailure() async {
         // Given
         mockService.shouldFail = true
         
         // When
         viewModel.getWeather(city: "Test")
         
         // Task'ın tamamlanmasını bekle
         try? await Task.sleep(nanoseconds: 1_000_000_000)
         
         // Then
         XCTAssertNil(viewModel.weather)
         XCTAssertNotNil(viewModel.errorMessage)
     }
 }
 #endif

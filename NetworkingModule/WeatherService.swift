import Foundation
// Uses APIConfig for endpoints

public struct WeatherEntry: Identifiable, Codable {
    public let id: UUID
    public let city: String
    public let temperatureC: Double
    public let windSpeed: Double
    public let weatherCode: Int
    public let time: String
}

// MARK: - Internal Decodable Structs

internal struct GeocodingResponse: Decodable {
    let results: [GeocodingResult]?
}

internal struct GeocodingResult: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
}

internal struct WeatherResponse: Decodable {
    let current_weather: CurrentWeather
}

internal struct CurrentWeather: Decodable {
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
}

// MARK: - Weather Service

public final class WeatherService {
    
    enum WeatherServiceError: Error, LocalizedError {
        case noGeocodingResults(String)
        case badGeocodingResponse
        case badWeatherResponse
        case invalidURL
        
        public var errorDescription: String? {
            switch self {
            case .noGeocodingResults(let city):
                return "No geocoding results found for city: \(city)"
            case .badGeocodingResponse:
                return "Failed to decode geocoding response."
            case .badWeatherResponse:
                return "Failed to decode weather response."
            case .invalidURL:
                return "Invalid URL constructed."
            }
        }
    }
    
    public init() {}
    
    public func geocode(city: String) async throws -> (name: String, latitude: Double, longitude: Double) {
        var components = URLComponents(url: APIConfig.geocodingSearchURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "name", value: city),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            throw WeatherServiceError.badGeocodingResponse
        }
        
        let decoded: GeocodingResponse
        do {
            decoded = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        } catch {
            throw WeatherServiceError.badGeocodingResponse
        }
        
        guard let result = decoded.results?.first else {
            throw WeatherServiceError.noGeocodingResults(city)
        }
        
        return (name: result.name, latitude: result.latitude, longitude: result.longitude)
    }
    
    public func fetchCurrentWeather(for city: String) async throws -> WeatherEntry {
        let location = try await geocode(city: city)
        
        var components = URLComponents(url: APIConfig.forecastURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: "\(location.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.longitude)"),
            URLQueryItem(name: "current_weather", value: "true")
        ]
        
        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            throw WeatherServiceError.badWeatherResponse
        }
        
        let decoded: WeatherResponse
        do {
            decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            throw WeatherServiceError.badWeatherResponse
        }
        
        let current = decoded.current_weather
        
        return WeatherEntry(
            id: UUID(),
            city: location.name,
            temperatureC: current.temperature,
            windSpeed: current.windspeed,
            weatherCode: current.weathercode,
            time: current.time
        )
    }
}


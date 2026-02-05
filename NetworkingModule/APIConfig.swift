import Foundation

public struct APIConfig {
    // MARK: - Base URLs
    public static let geocodingBaseString = "https://geocoding-api.open-meteo.com"
    public static let forecastBaseString = "https://api.open-meteo.com"

    public static let geocodingBaseURL = URL(string: geocodingBaseString)!
    public static let forecastBaseURL = URL(string: forecastBaseString)!

    // MARK: - Paths
    public static let geocodingSearchPath = "/v1/search"
    public static let forecastPath = "/v1/forecast"

    // MARK: - Convenience full endpoints
    public static var geocodingSearchURL: URL { geocodingBaseURL.appendingPathComponent(geocodingSearchPath) }
    public static var forecastURL: URL { forecastBaseURL.appendingPathComponent(forecastPath) }
}

public extension URLComponents {
    /// Helper to create URL by appending query items safely
    static func from(url: URL, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url
    }
}

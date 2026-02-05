import Foundation

struct WeatherCodeMapper {
    struct DescriptionIcon {
        let description: String
        let systemImage: String
    }

    static func map(_ code: Int) -> DescriptionIcon {
        switch code {
        case 0:
            return .init(description: "Clear sky", systemImage: "sun.max.fill")
        case 1:
            return .init(description: "Mainly clear", systemImage: "sun.min.fill")
        case 2:
            return .init(description: "Partly cloudy", systemImage: "cloud.sun.fill")
        case 3:
            return .init(description: "Overcast", systemImage: "cloud.fill")
        case 45, 48:
            return .init(description: "Fog", systemImage: "cloud.fog.fill")
        case 51, 53, 55:
            return .init(description: "Drizzle", systemImage: "cloud.drizzle.fill")
        case 56, 57:
            return .init(description: "Freezing drizzle", systemImage: "cloud.sleet.fill")
        case 61, 63, 65:
            return .init(description: "Rain", systemImage: "cloud.rain.fill")
        case 66, 67:
            return .init(description: "Freezing rain", systemImage: "cloud.hail.fill")
        case 71, 73, 75:
            return .init(description: "Snowfall", systemImage: "cloud.snow.fill")
        case 77:
            return .init(description: "Snow grains", systemImage: "snowflake")
        case 80, 81, 82:
            return .init(description: "Rain showers", systemImage: "cloud.heavyrain.fill")
        case 85, 86:
            return .init(description: "Snow showers", systemImage: "cloud.snow.fill")
        case 95:
            return .init(description: "Thunderstorm", systemImage: "cloud.bolt.rain.fill")
        case 96, 97:
            return .init(description: "Thunderstorm with hail", systemImage: "cloud.bolt.rain.fill")
        default:
            return .init(description: "Unknown", systemImage: "questionmark.circle")
        }
    }
}

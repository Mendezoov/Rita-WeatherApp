import Foundation
import Observation

@Observable final class WeatherViewModel {
    var cityInput: String = ""
    var entries: [WeatherEntry] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let service = WeatherService()

    @MainActor
    func fetch() async {
        let city = cityInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        do {
            let entry = try await service.fetchCurrentWeather(for: city)
            entries.insert(entry, at: 0)
            cityInput = ""
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

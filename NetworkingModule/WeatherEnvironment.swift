import SwiftUI
import Observation

private struct WeatherViewModelKey: EnvironmentKey {
    static let defaultValue: WeatherViewModel = WeatherViewModel()
}

extension EnvironmentValues {
    var weatherViewModel: WeatherViewModel {
        get { self[WeatherViewModelKey.self] }
        set { self[WeatherViewModelKey.self] = newValue }
    }
}

extension View {
    /// Inject a WeatherViewModel into the environment
    func weatherViewModel(_ model: WeatherViewModel) -> some View {
        environment(\..weatherViewModel, model)
    }
}

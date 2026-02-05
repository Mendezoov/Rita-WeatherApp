import SwiftUI
import Observation

// Simple mapper for weather code to SF Symbols
private func symbolName(for code: Int) -> String {
    switch code {
    case 0: return "sun.max.fill"
    case 1,2,3: return "cloud.sun.fill"
    case 45,48: return "cloud.fog.fill"
    case 51,53,55,56,57: return "cloud.drizzle.fill"
    case 61,63,65: return "cloud.rain.fill"
    case 66,67: return "cloud.hail.fill"
    case 71,73,75,77: return "cloud.snow.fill"
    case 80,81,82: return "cloud.heavyrain.fill"
    case 85,86: return "cloud.snow.fill"
    case 95: return "cloud.bolt.fill"
    case 96,99: return "cloud.bolt.rain.fill"
    default: return "cloud.fill"
    }
}

struct ContentView: View {
    @State private var viewModel = WeatherViewModel()
    @State private var showOnboarding: Bool = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            // Full-screen background gradient under all content
            LinearGradient(colors: [
                Color(#colorLiteral(red: 0.22, green: 0.12, blue: 0.45, alpha: 1)).opacity(0.95), // deep purple
                Color.indigo.opacity(0.9),
                Color.blue.opacity(0.85),
                Color.teal.opacity(0.85)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            Group {
                if showOnboarding && !hasSeenOnboarding {
                    // Onboarding as the initial root view
                    OnboardingView(isPresented: Binding(
                        get: { showOnboarding },
                        set: { newValue in
                            showOnboarding = newValue
                            if newValue == false { hasSeenOnboarding = true }
                        }
                    ))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Main app content
                    ZStack {
                        // Removed inner background gradient to avoid duplication

                        NavigationStack {
                            VStack(alignment: .leading, spacing: 16) {
                                
                                // Modern navigation header
                                HStack {
                                    VStack(alignment: .center, spacing: 2) {
                                        Text("Rita Weather")
                                            .font(.largeTitle).bold()
                                            .foregroundStyle(.white)
                                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                                            .padding(.horizontal, 60)
                                        Text("Search in Cities all Over The World")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundStyle(.white.opacity(0.85))
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(
                                            LinearGradient(colors: [
                                                Color.indigo.opacity(0.9),
                                                Color.blue.opacity(0.9),
                                                Color.cyan.opacity(0.9)
                                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                .padding(.bottom, 4)

                                ZStack {
                                    // Full-width modern gradient background bar
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.purple.opacity(0.55),
                                                    Color.indigo.opacity(0.55),
                                                    Color.blue.opacity(0.55),
                                                    Color.cyan.opacity(0.55)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                                        )
                                        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)

                                    HStack(alignment: .center, spacing: 10) {
                                        // Existing modern search field
                                        HStack(spacing: 8) {
                                            Image(systemName: "magnifyingglass")
                                                .foregroundStyle(.white.opacity(0.9))
                                            TextField(text: $viewModel.cityInput, prompt: Text("Enter Any city name").foregroundStyle(.black.opacity(0.9))) {
                                            }
                                            .foregroundStyle(.white)
                                            
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                        .background(
                                            LinearGradient(colors: [Color.indigo.opacity(0.85), Color.blue.opacity(0.85), Color.cyan.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .clipShape(Capsule())
                                        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
                                        .frame(minHeight: 40)
                                        .frame(maxWidth: 420)

                                        Button(action: { Task { await viewModel.fetch() } }) {
                                            HStack(spacing: 8) {
                                                if viewModel.isLoading {
                                                    ProgressView()
                                                        .tint(.white)
                                                } else {
                                                    Image(systemName: "cloud.sun.rain.fill")
                                                        .symbolRenderingMode(.palette)
                                                        .foregroundStyle(.white.opacity(0.95), .white.opacity(0.8))
                                                    Text("Fetch")
                                                        .fontWeight(.semibold)
                                   
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(
                                                LinearGradient(colors: [Color.indigo, Color.blue, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .clipShape(Capsule())
                                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                                        }
                                        .buttonStyle(.plain)
                                        .disabled(viewModel.cityInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                }
                                .frame(maxWidth: .infinity)
                                .ignoresSafeArea(edges: .horizontal)

                                if let error = viewModel.errorMessage {
                                    HStack(spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundStyle(.yellow)
                                        Text(error)
                                    }
                                    .font(.subheadline)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }

                                ScrollView {
                                    LazyVStack(spacing: 14) {
                                        ForEach(viewModel.entries) { entry in
                                            let gradient = LinearGradient(colors: [
                                                Color.blue.opacity(0.30),
                                                Color.cyan.opacity(0.30),
                                                Color.mint.opacity(0.30)
                                            ], startPoint: .topLeading, endPoint: .bottomTrailing)

                                            ZStack {
                                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                                    .fill(.ultraThinMaterial)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                                            .strokeBorder(gradient.opacity(0.8), lineWidth: 1)
                                                    )
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                                            .fill(gradient.opacity(0.35))
                                                    )
                                                VStack(alignment: .leading, spacing: 8) {
                                                    HStack(alignment: .firstTextBaseline) {
                                                        Image(systemName: symbolName(for: entry.weatherCode))
                                                            .symbolRenderingMode(.palette)
                                                            .foregroundStyle(Color.yellow, Color.orange)
                                                            .font(.system(size: 24))
                                                        Text(entry.city)
                                                            .font(.headline)
                                                            .foregroundStyle(.primary)
                                                        Spacer()
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "thermometer.sun.fill")
                                                                .foregroundStyle(.orange)
                                                            Text(String(format: "%.1f℃", entry.temperatureC))
                                                                .monospacedDigit()
                                                                .fontWeight(.semibold)
                                                        }
                                                        .font(.subheadline)
                                                    }
                                                    HStack(spacing: 14) {
                                                        Label(String(format: "%.1f m/s", entry.windSpeed), systemImage: "wind")
                                                            .labelStyle(.titleAndIcon)
                                                            .foregroundStyle(.secondary)
                                                        Label("Code: \(entry.weatherCode)", systemImage: "cloud.fill")
                                                            .labelStyle(.titleAndIcon)
                                                            .foregroundStyle(.secondary)
                                                        Spacer()
                                                        Text(entry.time)
                                                            .font(.footnote)
                                                            .foregroundStyle(.secondary)
                                                    }
                                                }
                                                .padding(14)
                                            }
                                            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)
                                        }
                                    }
                                }
                            }
                            .padding()
                            //.navigationTitle("Rita Weather")  // Removed per instructions
                            .toolbarBackground(.visible, for: .navigationBar)
                            .toolbarBackground(Color.clear, for: .navigationBar)
                        }
                    }
                }
            }
        }
        .onAppear {
            showOnboarding = !hasSeenOnboarding
        }
    }
}

#Preview {
    ContentView()
}


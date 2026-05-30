# Rita Weather

A SwiftUI weather app built as a capstone project for the CWC (Coding With Chris) course. Search any city in the world and get current weather conditions instantly.

## Features

- Search weather for any city worldwide
- Displays temperature (Celsius), wind speed, and weather condition
- Dynamic weather icons using SF Symbols
- Onboarding screen on first launch
- Beautiful gradient UI with glassmorphism card design
- Search history — all fetched cities are listed in the session

## Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with `@Observable`
- **Networking**: `async/await` with `URLSession`
- **Weather API**: [Open-Meteo](https://open-meteo.com/) — free, open-source, no API key required
- **Geocoding API**: [Open-Meteo Geocoding](https://open-meteo.com/en/docs/geocoding-api)

## Requirements

- Xcode 15 or later
- iOS 17 or later

## Getting Started

No API key or account needed. Just clone and run.

```bash
git clone https://github.com/YOUR_USERNAME/weather-app-capstone.git
cd weather-app-capstone
open NetworkingModule.xcodeproj
```

Select a simulator or device and press **Run** (⌘R).

## API

This app uses the free [Open-Meteo](https://open-meteo.com/) API:

| Endpoint | Purpose |
|---|---|
| `https://geocoding-api.open-meteo.com/v1/search` | City name → coordinates |
| `https://api.open-meteo.com/v1/forecast` | Coordinates → current weather |

No authentication, no rate-limit concerns for personal use.

## Project Structure

```
NetworkingModule/
├── APIConfig.swift          # Base URLs and endpoint constants
├── WeatherService.swift     # Networking layer (geocoding + weather fetch)
├── WeatherViewModel.swift   # Observable view model
├── WeatherCodeMapper.swift  # WMO weather code → description
├── WeatherEnvironment.swift # Environment values
├── ContentView.swift        # Main UI
├── OnboardingView.swift     # First-launch onboarding
└── NetworkingModuleApp.swift
```

## License

MIT License — free to use and modify.

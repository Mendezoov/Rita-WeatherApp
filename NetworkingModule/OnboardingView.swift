import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 64))
                .foregroundStyle(.tint)
            Text("Welcome to New Rita Weather App")
                .font(.title2).bold()
                .multilineTextAlignment(.center)
            Text("Quickly check the current weather for any city.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Get Started") { isPresented = false }
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}

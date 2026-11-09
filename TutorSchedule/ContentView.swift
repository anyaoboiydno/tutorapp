import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("TutorSchedule")
                .font(.title)
                .bold()
            Text("Лабораторна робота 1")
                .font(.headline)
            Text("Результати виконання логіки дивіться в консолі Xcode нижче.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

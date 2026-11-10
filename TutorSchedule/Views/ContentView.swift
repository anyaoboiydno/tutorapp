import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("TutorSchedule — MVVM")
                .font(.title2)
                .bold()
            
            Text("Неоплачених уроків: \(viewModel.unpaidCount)")
                .font(.headline)
                .foregroundColor(.orange)
            
            Divider()
            
            List(viewModel.lessons) { lesson in
                HStack {
                    VStack(alignment: .leading) {
                        Text(lesson.student)
                            .font(.headline)
                        Text(lesson.subject)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Button(action: {
                        if lesson.currentStatus == .pending {
                            viewModel.markAsPaid(lessonId: lesson.id)
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: lesson.currentStatus == .paid ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                            Text(lesson.currentStatus == .paid ? "Оплачено" : "Очікує оплати")
                        }
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .foregroundColor(lesson.currentStatus == .paid ? .green : .orange)
                        .background(lesson.currentStatus == .paid ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Button("Додати новий урок (Фабрика)") {
                viewModel.addLesson(student: "Олена", subject: "Math", price: 400)
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
        }
        .padding()
    }
}

import SwiftUI

struct LessonDetailView: View {
    let lessonId: UUID
    @ObservedObject var viewModel: ScheduleViewModel
    @ObservedObject var router: AppRouter
    
    @State private var isNotesExpanded: Bool = true
    @State private var badgeScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AppTheme.softBackground
                .ignoresSafeArea()
            
            ScrollView {
                if let lesson = viewModel.lesson(by: lessonId) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lesson.student)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(AppTheme.primaryText)
                                    Text(lesson.subject)
                                        .font(.headline)
                                        .foregroundColor(AppTheme.secondaryText)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(lesson.price) грн")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(AppTheme.accent)
                                    
                                    if let rate = lesson.usdRate, rate > 0 {
                                        Text(String(format: "≈ %.1f $ за курсом НБУ", Double(lesson.price) / rate))
                                            .font(.caption)
                                            .foregroundColor(AppTheme.secondaryText)
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack(spacing: 8) {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(AppTheme.accent)
                                Text(lesson.startTime.fullUkrainianDateTime())
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(AppTheme.primaryText)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(AppTheme.pillBackground.opacity(0.75))
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(AppTheme.border.opacity(0.6), lineWidth: 1)
                        )
                        .cornerRadius(14)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Статус оплати")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(AppTheme.secondaryText)
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                                    badgeScale = 1.06
                                    viewModel.togglePaymentStatus(lessonId: lesson.id)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        badgeScale = 1.0
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: lesson.currentStatus == .paid ? "checkmark.seal.fill" : "clock.badge.exclamationmark")
                                        .font(.title3)
                                    Text(lesson.currentStatus == .paid ? "Оплачено (натисніть, щоб змінити)" : "Очікує оплати (позначити як оплачено)")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                }
                                .padding()
                                .foregroundColor(lesson.currentStatus == .paid ? AppTheme.matchaGreen : AppTheme.accent)
                                .background(lesson.currentStatus == .paid ? AppTheme.matchaGreen.opacity(0.16) : AppTheme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lesson.currentStatus == .paid ? AppTheme.matchaGreen.opacity(0.5) : AppTheme.border, lineWidth: 1)
                                )
                                .cornerRadius(12)
                                .scaleEffect(badgeScale)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    isNotesExpanded.toggle()
                                }
                            }) {
                                HStack {
                                    Label("Домашнє завдання та нотатки", systemImage: "book.closed.fill")
                                        .font(.headline)
                                        .foregroundColor(AppTheme.primaryText)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppTheme.accent)
                                        .rotationEffect(.degrees(isNotesExpanded ? 0 : -90))
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if isNotesExpanded {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("ДЗ: \(lesson.homework ?? "Не задано")")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.primaryText)
                                    Divider()
                                    Text("Нотатка: \(lesson.note ?? "Нотаток поки немає")")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.secondaryText)
                                }
                                .padding(.top, 4)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(AppTheme.border.opacity(0.6), lineWidth: 1)
                        )
                        .cornerRadius(14)
                        
                        Button(role: .destructive, action: {
                            viewModel.deleteLesson(id: lesson.id)
                            router.pop()
                        }) {
                            HStack {
                                Spacer()
                                Label("Видалити урок із календаря", systemImage: "trash")
                                    .bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                } else {
                    Text("Урок не знайдено")
                        .foregroundColor(AppTheme.secondaryText)
                        .padding()
                }
            }
        }
        .navigationTitle("Деталі уроку")
        .toolbar {
            if let lesson = viewModel.lesson(by: lessonId) {
                ToolbarItem(placement: .primaryAction) {
                    Button("Редагувати") {
                        router.presentEditLesson(lesson)
                    }
                    .foregroundColor(AppTheme.accent)
                }
            }
        }
    }
}

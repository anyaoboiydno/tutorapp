import SwiftUI

struct ScheduleListView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @ObservedObject var router: AppRouter
    
    @State private var selectedDayFilter: DayFilter = .all
    @State private var showOnlyUnpaid = false
    
    private var sections: [LessonDaySection] {
        viewModel.groupedSections(dayFilter: selectedDayFilter, onlyUnpaid: showOnlyUnpaid)
    }
    
    var body: some View {
        ZStack {
            AppTheme.softBackground
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                headerCard
                contentArea
            }
        }
        .navigationTitle("TutorSchedule")
        .task {
            if viewModel.lessons.isEmpty && viewModel.loadState == .loading {
                await viewModel.loadLessons()
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Menu {
                    ForEach(DataSourceMode.allCases) { mode in
                        Button(action: {
                            Task {
                                await viewModel.switchDataSource(to: mode)
                            }
                        }) {
                            if viewModel.currentMode == mode {
                                Label(mode.rawValue, systemImage: "checkmark")
                            } else {
                                Text(mode.rawValue)
                            }
                        }
                    }
                } label: {
                    Label("Джерело даних", systemImage: "network")
                        .foregroundColor(AppTheme.accent)
                }
            }
            
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    Task {
                        await viewModel.loadLessons()
                    }
                }) {
                    Label("Оновити", systemImage: "arrow.clockwise")
                        .foregroundColor(AppTheme.accent)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    router.presentAddLesson()
                }) {
                    Label("Новий урок", systemImage: "plus.circle.fill")
                        .foregroundColor(AppTheme.accent)
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentArea: some View {
        switch viewModel.loadState {
        case .loading:
            loadingStateView
        case .error(let message):
            errorStateView(message: message)
        case .empty:
            emptyStateView(title: "Сервер повернув порожній розклад")
        case .loaded:
            if sections.isEmpty {
                emptyStateView(title: "За вибраним фільтром уроків немає")
            } else {
                lessonsListView
            }
        }
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Label(Date().calendarSectionTitle(), systemImage: "calendar")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(AppTheme.accent)
                    
                    Text("Усього уроків: \(viewModel.lessons.count) • Неоплачених: \(viewModel.unpaidCount)")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
                
                Spacer()
                
                Toggle(isOn: $showOnlyUnpaid.animation(.easeInOut)) {
                    Text("Неоплачені")
                        .font(.caption)
                        .bold()
                }
                .toggleStyle(.switch)
                .tint(AppTheme.accent)
                .labelsHidden()
                
                Text("Неоплачені")
                    .font(.caption)
                    .bold()
                    .foregroundColor(AppTheme.primaryText)
            }
            
            Picker("День", selection: $selectedDayFilter.animation(.easeInOut)) {
                ForEach(DayFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(12)
        .background(AppTheme.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.border, lineWidth: 1)
        )
        .cornerRadius(14)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var loadingStateView: some View {
        VStack(spacing: 14) {
            Spacer()
            ProgressView()
                .scaleEffect(1.3)
                .tint(AppTheme.accent)
            Text("Оновлення розкладу...")
                .font(.headline)
                .foregroundColor(AppTheme.primaryText)
            Spacer()
        }
        .padding()
    }
    
    private func emptyStateView(title: String) -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 42))
                .foregroundColor(AppTheme.accent)
            Text(title)
                .font(.headline)
                .foregroundColor(AppTheme.primaryText)
            Button("Оновити дані") {
                Task {
                    await viewModel.loadLessons()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            Spacer()
        }
        .padding()
    }
    
    private func errorStateView(message: String) -> some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 42))
                .foregroundColor(AppTheme.accent)
            
            Text("Не вдалося завантажити дані")
                .font(.headline)
                .foregroundColor(AppTheme.primaryText)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: {
                Task {
                    await viewModel.loadLessons()
                }
            }) {
                Label("Повторити запит", systemImage: "arrow.clockwise")
                    .bold()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            Spacer()
        }
        .padding()
    }
    
    private var lessonsListView: some View {
        List {
            ForEach(sections) { section in
                Section {
                    ForEach(section.lessons) { lesson in
                        lessonRow(for: lesson)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                } header: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(AppTheme.accent)
                        Text(section.title)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(AppTheme.primaryText)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func lessonRow(for lesson: Lesson) -> some View {
        Button(action: {
            router.showDetail(lessonId: lesson.id)
        }) {
            HStack(spacing: 12) {
                VStack(spacing: 2) {
                    Text(lesson.startTime.formattedTime())
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(AppTheme.accent)
                    Text("час")
                        .font(.caption2)
                        .foregroundColor(AppTheme.primaryText.opacity(0.75))
                }
                .frame(width: 54, height: 46)
                .background(AppTheme.pillBackground)
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.student)
                        .font(.headline)
                        .foregroundColor(AppTheme.primaryText)
                        .lineLimit(1)
                    Text("\(lesson.subject) • \(lesson.formattedPriceWithUSD)")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryText)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: lesson.currentStatus == .paid ? "checkmark.circle.fill" : "clock.fill")
                    Text(lesson.currentStatus.rawValue)
                }
                .font(.caption)
                .bold()
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .foregroundColor(lesson.currentStatus == .paid ? AppTheme.matchaGreen : AppTheme.accent)
                .background(lesson.currentStatus == .paid ? AppTheme.matchaGreen.opacity(0.16) : AppTheme.accent.opacity(0.14))
                .cornerRadius(8)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }
            .padding(10)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.border.opacity(0.6), lineWidth: 1)
            )
            .cornerRadius(12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

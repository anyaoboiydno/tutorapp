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
                
                if sections.isEmpty {
                    emptyStateView
                } else {
                    lessonsListView
                }
            }
        }
        .navigationTitle("Tutor Schedule")
        .toolbar {
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
    
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.accent)
            Text("На вибраний день уроків немає")
                .font(.headline)
                .foregroundColor(AppTheme.secondaryText)
            Spacer()
        }
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
                    Text("\(lesson.subject) • \(lesson.price) грн")
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

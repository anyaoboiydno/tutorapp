import SwiftUI

enum AppTheme {
    static let primaryText = Color(red: 0.26, green: 0.16, blue: 0.14)
    static let secondaryText = Color(red: 0.48, green: 0.35, blue: 0.32)
    static let accent = Color(red: 0.85, green: 0.26, blue: 0.46)
    static let matchaGreen = Color(red: 0.33, green: 0.54, blue: 0.31)
    static let softBackground = Color(red: 0.99, green: 0.95, blue: 0.96)
    static let cardBackground = Color(red: 0.97, green: 0.89, blue: 0.92)
    static let pillBackground = Color(red: 0.95, green: 0.82, blue: 0.87)
    static let border = Color(red: 0.88, green: 0.68, blue: 0.75)        
}

struct ContentView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @ObservedObject var router: AppRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScheduleListView(viewModel: viewModel, router: router)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .lessonDetail(let lessonId):
                        LessonDetailView(
                            lessonId: lessonId,
                            viewModel: viewModel,
                            router: router
                        )
                    }
                }
        }
        .tint(AppTheme.accent)
        .environment(\.colorScheme, .light)
        .sheet(item: $router.activeModal) { modal in
            switch modal {
            case .addLesson:
                LessonFormView(viewModel: viewModel, router: router, lessonToEdit: nil)
            case .editLesson(let lesson):
                LessonFormView(viewModel: viewModel, router: router, lessonToEdit: lesson)
            }
        }
    }
}

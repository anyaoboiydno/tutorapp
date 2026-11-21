import SwiftUI

@main
struct TutorScheduleApp: App {
    @StateObject private var viewModel: ScheduleViewModel
    @StateObject private var router = AppRouter()

    init() {
        let baseService = MockLessonService()
        let loggingService = LoggingLessonService(wrappedService: baseService)
        
        _viewModel = StateObject(
            wrappedValue: ScheduleViewModel(service: loggingService)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, router: router)
        }
        .defaultSize(width: 480, height: 640)
    }
}

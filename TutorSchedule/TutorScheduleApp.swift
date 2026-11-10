import SwiftUI

@main
struct TutorScheduleApp: App {
    @StateObject private var viewModel: ScheduleViewModel

    init() {
        let baseService = MockLessonService()
        
        //let baseService = DemoLessonService()
        
        let loggingService = LoggingLessonService(wrappedService: baseService)
        
        _viewModel = StateObject(
            wrappedValue: ScheduleViewModel(service: loggingService)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}

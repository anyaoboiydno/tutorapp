import SwiftUI

@main
struct TutorScheduleApp: App {
    @StateObject private var viewModel: ScheduleViewModel
    @StateObject private var router = AppRouter()

    init() {
        let makeService: (DataSourceMode) -> LessonServiceProtocol = { mode in
            let baseService: LessonServiceProtocol
            switch mode {
            case .realAPI:
                let apiClient = APIClient(baseURL: "https://jsonplaceholder.typicode.com")
                baseService = NetworkLessonService(apiClient: apiClient)
            case .stubEmpty:
                baseService = StubLessonService(scenario: .emptyResponse)
            case .stubHttpError:
                baseService = StubLessonService(scenario: .httpServerError)
            case .stubTransportError:
                baseService = StubLessonService(scenario: .transportOfflineError)
            case .stubDecodingError:
                baseService = StubLessonService(scenario: .decodingFormatError)
            }
            return LoggingLessonService(wrappedService: baseService)
        }
        
        let initialService = makeService(.realAPI)
        _viewModel = StateObject(
            wrappedValue: ScheduleViewModel(
                service: initialService,
                serviceFactory: makeService
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, router: router)
        }
        .defaultSize(width: 520, height: 680)
    }
}

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case lessonDetail(lessonId: UUID)
}

enum ModalRoute: Identifiable {
    case addLesson
    case editLesson(Lesson)
    
    var id: String {
        switch self {
        case .addLesson:
            return "addLesson"
        case .editLesson(let lesson):
            return "editLesson-\(lesson.id.uuidString)"
        }
    }
}

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var activeModal: ModalRoute?
    
    func showDetail(lessonId: UUID) {
        path.append(AppRoute.lessonDetail(lessonId: lessonId))
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func presentAddLesson() {
        activeModal = .addLesson
    }
    
    func presentEditLesson(_ lesson: Lesson) {
        activeModal = .editLesson(lesson)
    }
    
    func dismissModal() {
        activeModal = nil
    }
}

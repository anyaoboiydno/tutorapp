import SwiftUI

struct LessonFormView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @ObservedObject var router: AppRouter
    let lessonToEdit: Lesson?
    
    @State private var student: String
    @State private var subject: String
    @State private var priceText: String
    @State private var startTime: Date
    @State private var status: PaymentStatus
    @State private var homework: String
    @State private var note: String
    
    private let quickSubjects = ["English", "Математика", "Українська", "Програмування"]
    private let quickPrices = [400, 500, 600, 650]
    
    init(viewModel: ScheduleViewModel, router: AppRouter, lessonToEdit: Lesson? = nil) {
        self.viewModel = viewModel
        self.router = router
        self.lessonToEdit = lessonToEdit
        
        _student = State(initialValue: lessonToEdit?.student ?? "")
        _subject = State(initialValue: lessonToEdit?.subject ?? "English")
        _priceText = State(initialValue: lessonToEdit != nil ? "\(lessonToEdit!.price)" : "500")
        _startTime = State(initialValue: lessonToEdit?.startTime ?? Date())
        _status = State(initialValue: lessonToEdit?.currentStatus ?? .pending)
        _homework = State(initialValue: lessonToEdit?.homework ?? "")
        _note = State(initialValue: lessonToEdit?.note ?? "")
    }
    
    private var isFormValid: Bool {
        !student.trimmingCharacters(in: .whitespaces).isEmpty &&
        !subject.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Int(priceText) ?? 0) > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Ім'я учня (обов'язково)", text: $student)
                    
                    TextField("Предмет (або оберіть нижче)", text: $subject)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickSubjects, id: \.self) { item in
                                Button(action: {
                                    subject = item
                                }) {
                                    Text(item)
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(subject == item ? AppTheme.accent : AppTheme.pillBackground)
                                        .foregroundColor(subject == item ? .white : AppTheme.primaryText)
                                        .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                } header: {
                    Text("Учень та предмет")
                        .foregroundColor(AppTheme.accent)
                }
                
                Section {
                    TextField("Вартість у грн (введіть будь-яку суму)", text: $priceText)
                        .onChange(of: priceText) { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue {
                                priceText = filtered
                            }
                        }
                    
                    HStack(spacing: 8) {
                        ForEach(quickPrices, id: \.self) { preset in
                            Button(action: {
                                priceText = "\(preset)"
                            }) {
                                Text("\(preset) грн")
                                    .font(.caption)
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(priceText == "\(preset)" ? AppTheme.accent : AppTheme.pillBackground)
                                    .foregroundColor(priceText == "\(preset)" ? .white : AppTheme.primaryText)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 2)
                } header: {
                    Text("Вартість заняття")
                        .foregroundColor(AppTheme.accent)
                }
                
                Section {
                    DatePicker("День та година", selection: $startTime)
                } header: {
                    Text("Дата і час у календарі")
                        .foregroundColor(AppTheme.accent)
                }
                
                Section {
                    Picker("Статус", selection: $status) {
                        ForEach(PaymentStatus.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                } header: {
                    Text("Оплата")
                        .foregroundColor(AppTheme.accent)
                }
                
                Section {
                    TextField("Домашнє завдання", text: $homework)
                    TextField("Нотатка для себе", text: $note)
                } header: {
                    Text("Матеріали до уроку")
                        .foregroundColor(AppTheme.accent)
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(AppTheme.softBackground)
            .foregroundColor(AppTheme.primaryText)
            .navigationTitle(lessonToEdit == nil ? "Новий урок" : "Редагування уроку")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати") {
                        router.dismissModal()
                    }
                    .foregroundColor(AppTheme.secondaryText)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Зберегти") {
                        saveLesson()
                    }
                    .bold()
                    .foregroundColor(isFormValid ? AppTheme.accent : .gray)
                    .disabled(!isFormValid)
                }
            }
        }
        .tint(AppTheme.accent)
        .environment(\.colorScheme, .light)
        .frame(minWidth: 420, minHeight: 520)
    }
    
    private func saveLesson() {
        let parsedPrice = Int(priceText) ?? 500
        let cleanHomework = homework.trimmingCharacters(in: .whitespaces)
        let cleanNote = note.trimmingCharacters(in: .whitespaces)
        
        if var existing = lessonToEdit {
            existing.student = student.trimmingCharacters(in: .whitespaces)
            existing.subject = subject.trimmingCharacters(in: .whitespaces)
            existing.price = parsedPrice
            existing.startTime = startTime
            existing.currentStatus = status
            existing.homework = cleanHomework.isEmpty ? nil : cleanHomework
            existing.note = cleanNote.isEmpty ? nil : cleanNote
            viewModel.updateLesson(existing)
        } else {
            viewModel.addLesson(
                student: student.trimmingCharacters(in: .whitespaces),
                subject: subject.trimmingCharacters(in: .whitespaces),
                price: parsedPrice,
                startTime: startTime,
                isPaid: status == .paid,
                homework: cleanHomework,
                note: cleanNote
            )
        }
        router.dismissModal()
    }
}

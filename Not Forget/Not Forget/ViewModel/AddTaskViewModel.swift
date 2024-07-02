import Foundation
import SwiftUI
import Combine

class AddTaskViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var deadline: Date = Date()
    @Published var selectedPriority: String = "Select Priority"
    @Published var isDatePickerPresented: Bool = false
    @Published var tasks: [TasksModel] = [] {
        didSet {
            objectWillChange.send()
            saveTasks() 
        }
    }
    
    @Published private(set) var descriptionCount: Int = 0
    let descriptionLimit = 120
    let priorities = ["Some Day", "Not Important", "Normal", "Important"]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadTasks() // Load tasks when the view model is initialized
    }
    
    private func setupBindings() {
        $description
            .sink { [weak self] newValue in
                if newValue.count <= self?.descriptionLimit ?? 0 {
                    self?.descriptionCount = newValue.count
                } else {
                    self?.description = String(newValue.prefix(self?.descriptionLimit ?? 0))
                }
            }
            .store(in: &cancellables)
    }
    
    func saveTask(title: String, description: String, deadline: Date, priority: String) {
        let newTask = TasksModel(title: title, description: description, deadline: deadline, priority: priority)
        tasks.append(newTask)
        clearForm()
    }
    
    func updateTask(task: TasksModel, title: String, description: String, deadline: Date, priority: String) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].title = title
            tasks[index].description = description
            tasks[index].deadline = deadline
            tasks[index].priority = priority
        }
        clearForm()
    }

    func completeTask(_ task: TasksModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed.toggle()
        }
    }
    
    func deleteTask(_ task: TasksModel) {
        tasks.removeAll(where: { $0.id == task.id })
    }
    
    private func clearForm() {
        title = ""
        description = ""
        deadline = Date()
        selectedPriority = "Select Priority"
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func addTask(_ task: TasksModel) {
        tasks.insert(task, at: 0)
    }
    private let tasksKey = "savedTasks"
    
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: tasksKey)
        } catch {
            print("Error saving tasks: \(error.localizedDescription)")
        }
    }
    
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey) {
            do {
                tasks = try JSONDecoder().decode([TasksModel].self, from: data)
            } catch {
                print("Error loading tasks: \(error.localizedDescription)")
            }
        }
    }
}

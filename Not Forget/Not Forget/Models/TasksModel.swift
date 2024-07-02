



import Foundation

struct TasksModel: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var deadline: Date
    var priority: String
    var completed: Bool = false
}



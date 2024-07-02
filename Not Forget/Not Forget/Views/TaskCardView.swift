import SwiftUI

struct TaskCardView: View {
    let task: TasksModel
    let onComplete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.headline)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Button(action: {
                        onComplete()
                    }) {
                        Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(task.completed ? .white : .primary)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
        .background(priorityColor())
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private func priorityColor() -> Color {
        switch task.priority {
        case "Important":
            return Color.red
        case "Normal":
            return Color.green
        case "Not Important":
            return Color.yellow
        case "Some Day":
            return Color.blue
        default:
            return Color.gray
        }
    }
}

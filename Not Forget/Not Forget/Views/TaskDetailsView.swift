import SwiftUI

struct TaskDetailsView: View {
    @EnvironmentObject var viewModel: AddTaskViewModel
    var task: TasksModel
    @State private var navigateToEdit = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(task.title)
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    navigateToEdit = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .padding()
                       
                        .foregroundColor(.blue)
                        .cornerRadius(5)
                }
                .padding(.trailing, 16)
            }
            
            Text(task.description)
                .font(.body)
                .padding()

            HStack {
                Image(systemName: "clock")
                    .padding(.trailing, 8)
                Text(viewModel.formattedDate(task.deadline))
                    .foregroundColor(.secondary)
                Spacer()
                priorityLabel(priority: task.priority)
            }
            .font(.subheadline)
            .padding(.top, 8)

            if task.completed {
                Text("Completed")
                    .foregroundColor(.green) 
                    .font(.headline)
                    .padding(.top, 8)
            } else {
                Text("Status: not complete")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .navigationBarTitle("Task Details", displayMode: .inline)
        .sheet(isPresented: $navigateToEdit) {
            AddTaskView(taskToEdit: task)
                .environmentObject(viewModel)
        }
    }
    
    private func priorityLabel(priority: String) -> some View {
        let color: Color
        switch priority {
        case "Important":
            color = .red
        case "Normal":
            color = .green
        case "Not Important":
            color = .yellow
        case "Some Day":
            color = .blue
        default:
            color = .gray
        }
        
        return Text(priority)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10).fill(color))
            .foregroundColor(.white)
            .font(.subheadline)
    }
}

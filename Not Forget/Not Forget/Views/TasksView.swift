import SwiftUI

struct TasksView: View {
    @ObservedObject var viewModel: AddTaskViewModel
    @State private var selectedTask: TasksModel? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.tasks.reversed(), id: \.id) { task in
                        TaskCardView(task: task) {
                            viewModel.completeTask(task)
                        }
                        .onTapGesture {
                            selectedTask = task
                        }
                        .contextMenu {
                            Button(action: {
                                viewModel.deleteTask(task)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Tasks")
            .navigationBarItems(trailing:
                NavigationLink(destination: AddTaskView().environmentObject(viewModel)) {
                    Image(systemName: "plus")
                }
            )
            .sheet(item: $selectedTask) { task in
                TaskDetailsView(task: task)
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.loadTasks()
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(viewModel: AddTaskViewModel())
    }
}

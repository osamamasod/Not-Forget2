import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var viewModel: AddTaskViewModel
    @State private var navigateToTasks = false
    @State private var showError = false
    var taskToEdit: TasksModel? = nil

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var deadline: Date = Date()
    @State private var selectedPriority: String = "Select Priority"
    
    init(taskToEdit: TasksModel? = nil) {
        self.taskToEdit = taskToEdit
        if let task = taskToEdit {
            _title = State(initialValue: task.title)
            _description = State(initialValue: task.description)
            _deadline = State(initialValue: task.deadline)
            _selectedPriority = State(initialValue: task.priority)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Add Task")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Task Title", text: $title)
                        .padding()
                        .cornerRadius(5)
                        .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                    
                    VStack(alignment: .leading) {
                        Text("Task Description")
                            .font(.headline)
                        TextEditor(text: $description)
                            .padding()
                            .cornerRadius(5)
                            .frame(height: 160)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .onChange(of: description) { newValue in
                                description = String(newValue.prefix(viewModel.descriptionLimit))
                            }
                        Text("\(description.count)/\(viewModel.descriptionLimit)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        TextField("Deadline", text: Binding(
                            get: { viewModel.formattedDate(deadline) },
                            set: { _ in }
                        ))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disabled(true)
                        
                        Button(action: {
                            viewModel.isDatePickerPresented.toggle()
                            UIApplication.shared.endEditing() // Dismiss keyboard
                        }) {
                            Image(systemName: "calendar")
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(5)
                        }
                        .sheet(isPresented: $viewModel.isDatePickerPresented) {
                            DatePicker(
                                "Select Deadline",
                                selection: $deadline,
                                displayedComponents: .date
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                        }
                    }
                    
                    Menu {
                        Picker(selection: $selectedPriority, label: Text("Priority")) {
                            ForEach(viewModel.priorities, id: \.self) { priority in
                                Text(priority).tag(priority)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedPriority)
                                .foregroundColor(selectedPriority == "Select Priority" ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                    }
                    
                    Button(action: {
                        if title.isEmpty && description.isEmpty {
                            showError = true
                        } else {
                            if let task = taskToEdit {
                                viewModel.updateTask(task: task, title: title, description: description, deadline: deadline, priority: selectedPriority)
                            } else {
                                viewModel.saveTask(title: title, description: description, deadline: deadline, priority: selectedPriority)
                            }
                            navigateToTasks = true
                            UIApplication.shared.endEditing() // Dismiss keyboard
                        }
                    }) {
                        Text("Save")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    .fullScreenCover(isPresented: $navigateToTasks) {
                        TasksView(viewModel: viewModel)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    }
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text("The Title or the description should be filled."), dismissButton: .default(Text("OK")))
                    }
                    
                    Spacer()
                }
                .padding()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView().environmentObject(AddTaskViewModel())
    }
}

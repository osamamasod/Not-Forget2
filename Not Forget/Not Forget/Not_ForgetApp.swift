

import SwiftUI

@main
struct Not_ForgetApp: App {
    @StateObject private var viewModel = AddTaskViewModel()
    
    var body: some Scene {
        WindowGroup {
            if viewModel.tasks.isEmpty {
                ContentView()
                    .environmentObject(viewModel)
            } else {
                TasksView(viewModel: viewModel)
                    .environmentObject(viewModel)
            }
        }
    }
}

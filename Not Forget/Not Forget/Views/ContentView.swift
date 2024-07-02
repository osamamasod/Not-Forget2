import SwiftUI

struct ContentView: View {
    @State private var isAddingTask = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Not Forget")
                    .font(.largeTitle)
                
                Spacer()
                
                Image("to do")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 200)
                
                Text("For now you have nothing to do.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    isAddingTask = true
                }) {
                    Image(systemName: "plus")
                        .frame(width: 70, height: 70) // Square dimensions
                        .background(RoundedRectangle(cornerRadius: 13).fill(Color.black))
                        .foregroundColor(.white)
                }
                .padding(.leading, 200) // Move button to the right
                .padding(.bottom, 50)
                .fullScreenCover(isPresented: $isAddingTask) {
                    AddTaskView()
                        .environmentObject(AddTaskViewModel())
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AddTaskViewModel())
    }
}

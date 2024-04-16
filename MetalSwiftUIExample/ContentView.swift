import SwiftUI

struct ContentView: View {
    @State var speed: Float = 1.0
    var body: some View {
        ZStack {
            CubeView(speed: speed)
                .ignoresSafeArea()
            DraggableExampleView(speed: $speed)
        }
        /*
        .overlay(alignment: .bottomTrailing) {
            CubeView(speed: speed)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
        }
         */
    }
}

#Preview {
    ContentView()
}

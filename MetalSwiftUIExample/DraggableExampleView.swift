import SwiftUI

struct CardView: View {
    var body: some View {
        Text("Drag me")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
    }
}

struct DraggableExampleView: View {
    @State var dragAmount: CGFloat = 0
    @Binding var speed : Float

    var body: some View {
        VStack {
            CardView()
            CardView()
            CardView()
            CardView()
            CardView()
            Slider(
                value: $speed,
                in: 0.01...10.0,
                onEditingChanged: { _ in      }
            )
        }
        .padding()
        .compositingGroup()
        .shadow(color: .red, radius: 10, x: 0, y: 2)
        .offset(y: dragAmount)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    dragAmount = gesture.translation.height
                }
                .onEnded { _ in
                    withAnimation {
                        dragAmount = .zero
                    }
                }
        )
    }
}

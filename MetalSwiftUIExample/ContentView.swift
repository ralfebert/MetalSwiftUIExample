//
//  ContentView.swift
//  MetalSwiftUIExample
//
//  Created by Ralf Ebert on 11.04.24.
//

import SwiftUI

struct MyView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GameViewController {
        GameViewController()
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        
    }
}
struct ContentView: View {
    @State var value = 0.0
    var body: some View {
        ZStack {
            MyView()
                .ignoresSafeArea()
            Slider(value: $value, in: 0...100, onEditingChanged: { editing in
               
            })
        }
    }
}

#Preview {
    ContentView()
}

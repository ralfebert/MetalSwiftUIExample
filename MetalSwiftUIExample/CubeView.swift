//
//  CubeView.swift
//  MetalSwiftUIExample
//
//  Created by Ralf Ebert on 16.04.24.
//

import SwiftUI

struct CubeView: UIViewControllerRepresentable {
    var speed: Float = 1.0
    
    func makeUIViewController(context: Context) -> GameViewController {
        GameViewController()
    }

    func updateUIViewController(_ controller: GameViewController, context: Context) {
        controller.speed = speed
    }
}

#Preview {
    CubeView()
}

//
//  GameViewController.swift
//  MetalGame
//
//  Created by Ralf Ebert on 11.04.24.
//

import UIKit
import MetalKit

// Our iOS specific view controller
class GameViewController: UIViewController {

    var renderer: Renderer!
    var mtkView: MetalView!

    override func loadView() {
        self.view = MetalView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let metalView = view as? MetalView else {
            print("View of Gameview controller is not an MTKView")
            return
        }

        metalView.backgroundColor = UIColor.black

        guard let newRenderer = Renderer(metalKitView: metalView) else {
            print("Renderer cannot be initialized")
            return
        }

        renderer = newRenderer

        metalView.delegate = renderer
    }
}

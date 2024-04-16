import MetalKit
import UIKit

// Our iOS specific view controller
class GameViewController: UIViewController {
    var renderer: Renderer!
    var mtkView: MTKView!
    
    var speed: Float {
        get { renderer.speed }
        set { renderer.speed = newValue }
    }

    override func loadView() {
        view = MetalView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let metalView = view as? MetalView else {
            print("View of Gameview controller is not an MTKView")
            return
        }

        // Select the device to render with.  We choose the default device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported")
            return
        }

        metalView.backgroundColor = UIColor.black

        guard let newRenderer = Renderer(metalView: metalView) else {
            print("Renderer cannot be initialized")
            return
        }

        self.renderer = newRenderer

        metalView.delegate = newRenderer
    }
}

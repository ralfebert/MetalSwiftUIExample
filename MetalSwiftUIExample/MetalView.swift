//
//  MetalView.swift
//  MetalSwiftUIExample
//
//  Created by Ralf Ebert on 11.04.24.
//

import UIKit
import Metal

protocol MetalViewDelegate: AnyObject {
    func draw(in view: MetalView, drawable: CAMetalDrawable)
    func mtkView(_ view: MetalView, drawableSizeWillChange size: CGSize)
}

open class MetalView: UIView, CAMetalDisplayLinkDelegate {

    /// The delegate of this view, responsible for drawing
    weak var delegate: MetalViewDelegate?

    /// The Metal layer that backs this view
    var metalLayer: CAMetalLayer!

    override open class var layerClass: AnyClass {
        CAMetalLayer.self
    }

    /// The desired pixel format of the color attachment
    var colorPixelFormat: MTLPixelFormat {
        self.metalLayer.pixelFormat
    }

    let device: MTLDevice

    var displayLink: CAMetalDisplayLink!

    init() {
        // Select the device to render with.  We choose the default device
        self.device = MTLCreateSystemDefaultDevice()!

        super.init(frame: .zero)

        self.metalLayer = self.layer as! CAMetalLayer
        self.metalLayer.pixelFormat = MTLPixelFormat.bgra8Unorm
        self.metalLayer.device = device
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.stopRenderLoop()
    }

    func setColorPixelFormat(colorPixelFormat: MTLPixelFormat) {
        self.metalLayer.pixelFormat = colorPixelFormat
    }

    override open func didMoveToWindow() {
        guard let window = self.window else {
            self.displayLink.invalidate()
            self.displayLink = nil
            return
        }

        self.setupCADisplayLink(for: window.screen)
        self.displayLink.add(to: .current, forMode: .common)

        self.resizeDrawable()
    }

    func setupCADisplayLink(for screen: UIScreen) {
        self.stopRenderLoop()
        self.displayLink = CAMetalDisplayLink(metalLayer: self.metalLayer)
        self.displayLink.delegate = self
        self.displayLink.isPaused = self.isPaused
    }

    func stopRenderLoop() {
        self.displayLink?.invalidate()
    }

    public func metalDisplayLink(_ link: CAMetalDisplayLink, needsUpdate update: CAMetalDisplayLink.Update) {
        self.delegate?.draw(in: self, drawable:  update.drawable)
    }

    var isPaused: Bool = false {
        didSet {
            self.displayLink?.isPaused = isPaused
            print("isPaused", isPaused)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.resizeDrawable()
    }

    func resizeDrawable() {
        guard let window = self.window else { return }
        var newSize = self.bounds.size
        let scaleFactor = window.screen.nativeScale
        newSize.width *= scaleFactor
        newSize.height *= scaleFactor
        if newSize != self.metalLayer.drawableSize {
            self.metalLayer.drawableSize = newSize
        }
        self.delegate?.mtkView(self, drawableSizeWillChange: newSize)
    }

}

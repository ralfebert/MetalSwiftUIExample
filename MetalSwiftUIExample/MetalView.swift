//
//  MetalView.swift
//  MetalSwiftUIExample
//
//  Created by Ralf Ebert on 11.04.24.
//

import UIKit
import Metal
import os

protocol MetalViewDelegate: AnyObject {
    func draw(in view: MetalView)
    func mtkView(_ view: MetalView, drawableSizeWillChange size: CGSize)
}

open class MetalView: UIView {

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

    /// The color to which the color attachment should be cleared at the start of
    /// a rendering pass
    var clearColor = MTLClearColorMake(0, 0.5, 0, 1)

    var displayLink: CADisplayLink!

    init() {
        // Select the device to render with.  We choose the default device
        self.device = MTLCreateSystemDefaultDevice()!

        super.init(frame: .zero)

        self.metalLayer = self.layer as! CAMetalLayer
        self.metalLayer.pixelFormat = MTLPixelFormat.bgra8Unorm
        self.metalLayer.device = device
        self.metalLayer.presentsWithTransaction = true
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
        self.displayLink = screen.displayLink(withTarget: self, selector: #selector(self.render(displayLink:)))
        self.displayLink.isPaused = self.isPaused
    }

    func stopRenderLoop() {
        self.displayLink?.invalidate()
    }
    
    let signposter = OSSignposter()

    @objc func render(displayLink: CADisplayLink) {
        self.delegate?.draw(in: self)
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

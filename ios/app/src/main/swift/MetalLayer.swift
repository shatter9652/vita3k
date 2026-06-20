import MetalKit
import SwiftUI

extension MTKView {
    func makeCAMetalLayer() -> CAMetalLayer {
        let layer = self.layer as! CAMetalLayer
        layer.device = self.device
        layer.pixelFormat = self.colorPixelFormat
        layer.framebufferOnly = false
        return layer
    }
}

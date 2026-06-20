import Metal
import MetalKit

class Renderer {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue

    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
    }

    func draw(in view: MTKView, emulator: EmulatorViewModel) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else { return }

        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!

        // Vita3K renders here via Metal interop or GLES-on-Metal
        encoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

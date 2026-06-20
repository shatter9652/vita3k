import SwiftUI
import MetalKit

struct ContentView: View {
    @StateObject private var emulator = EmulatorViewModel()

    var body: some View {
        ZStack {
            if emulator.isEmulating {
                EmulationView(emulator: emulator)
                    .ignoresSafeArea()
            } else {
                AppsListView(emulator: emulator)
            }
        }
    }
}

struct EmulationView: View {
    @ObservedObject var emulator: EmulatorViewModel

    var body: some View {
        ZStack {
            MetalView(emulator: emulator)
                .ignoresSafeArea()

            InputOverlayView(emulator: emulator)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Pause") {
                    emulator.pause()
                }
            }
        }
    }
}

struct MetalView: UIViewRepresentable {
    @ObservedObject var emulator: EmulatorViewModel

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.delegate = context.coordinator
        view.preferredFramesPerSecond = 60
        view.isPaused = false
        view.enableSetNeedsDisplay = false
        view.framebufferOnly = false
        // MoltenVK will use this CAMetalLayer
        _ = view.makeCAMetalLayer()
        return view
    }

    func updateUIView(_ uiView: MTKView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(emulator: emulator)
    }

    class Coordinator: NSObject, MTKViewDelegate {
        let emulator: EmulatorViewModel
        let renderer: Renderer

        init(emulator: EmulatorViewModel) {
            self.emulator = emulator
            self.renderer = Renderer(device: MTLCreateSystemDefaultDevice()!)
            super.init()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

        func draw(in view: MTKView) {
            renderer.draw(in: view, emulator: emulator)
        }
    }
}

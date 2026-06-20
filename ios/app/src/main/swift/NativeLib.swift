import Foundation

class NativeLib {
    static let shared = NativeLib()
    private var handle: OpaquePointer?

    private init() {
        handle = vita3k_create()
    }

    func launch(path: String) {
        _ = vita3k_launch(handle, path)
    }

    func pause(_ paused: Bool) {
        vita3k_pause(handle, paused)
    }

    func stop() {
        vita3k_stop(handle)
    }

    func enableJIT() {
        _ = StikDebugJIT.enable()
    }
}

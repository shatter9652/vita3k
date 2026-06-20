import Foundation
import Combine

class EmulatorViewModel: ObservableObject {
    @Published var isEmulating = false
    @Published var isPaused = false
    @Published var currentGame: String?

    private var nativeHandle: OpaquePointer?

    func launchGame(path: String) {
        currentGame = path
        isEmulating = true
        NativeLib.shared.launch(path: path)
    }

    func pause(_ paused: Bool) {
        isPaused.toggle()
        NativeLib.shared.pause(isPaused)
    }

    func stop() {
        NativeLib.shared.stop()
        isEmulating = false
        currentGame = nil
    }
}

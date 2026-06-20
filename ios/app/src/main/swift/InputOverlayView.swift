import SwiftUI

struct InputOverlayView: View {
    @ObservedObject var emulator: EmulatorViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                DPadView()
                    .position(x: 100, y: geometry.size.height - 150)

                ActionButtonsView()
                    .position(x: geometry.size.width - 120, y: geometry.size.height - 150)

                JoystickView()
                    .position(x: 80, y: geometry.size.height - 80)
                JoystickView()
                    .position(x: geometry.size.width - 80, y: geometry.size.height - 80)
            }
        }
    }
}

struct DPadView: View {
    var body: some View {
        Image(systemName: "dpad")
            .font(.system(size: 80))
            .opacity(0.6)
    }
}

struct ActionButtonsView: View {
    var body: some View {
        VStack {
            Circle().frame(width: 40).opacity(0.6)
            HStack {
                Circle().frame(width: 40).opacity(0.6)
                Circle().frame(width: 40).opacity(0.6)
            }
            Circle().frame(width: 40).opacity(0.6)
        }
    }
}

struct JoystickView: View {
    var body: some View {
        Circle()
            .stroke(Color.white.opacity(0.6), lineWidth: 4)
            .frame(width: 80, height: 80)
    }
}

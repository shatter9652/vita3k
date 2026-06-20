import SwiftUI

struct AppsListView: View {
    @ObservedObject var emulator: EmulatorViewModel
    @State private var games: [String] = ["Persona 4 Golden", "Gravity Rush"]

    var body: some View {
        NavigationView {
            List(games, id: \.self) { game in
                Button(game) {
                    emulator.launchGame(path: game)
                }
            }
            .navigationTitle("Vita3K")
        }
    }
}

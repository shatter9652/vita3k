import SwiftUI

struct MoreRAMView: View {
    @StateObject private var vm = MoreRAMViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if vm.isLoading {
                    ProgressView()
                }

                List {
                    if !vm.isLoggedIn {
                        Button("Sign in with Apple ID") {
                            Task { await vm.login() }
                        }
                    } else {
                        ForEach(vm.appIDs) { model in
                            HStack {
                                Text(model.bundleID)
                                Spacer()
                                Button("Add More RAM") {
                                    Task { await vm.addIncreasedMemory(to: model) }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }

                if !vm.statusMessage.isEmpty {
                    Text(vm.statusMessage)
                        .font(.footnote)
                        .padding()
                }
            }
            .navigationTitle("More RAM")
            .task {
                if vm.isLoggedIn { await vm.fetchAppIDs() }
            }
        }
    }
}

import Foundation
import StosSign

final class DataManager {
    static let shared = DataManager()
    let model = SessionModel()

    private init() {}
}

final class SessionModel: ObservableObject {
    @Published var team: Team?
    @Published var session: AppleAPISession?
}

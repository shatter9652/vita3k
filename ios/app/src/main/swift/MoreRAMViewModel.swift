import SwiftUI
import StosSign

@MainActor
final class MoreRAMViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var appIDs: [AppIDModel] = []
    @Published var statusMessage = ""
    @Published var isLoading = false

    func login() async {
        // TODO: Present Anisette login UI (reuse SideStore/AnisetteDataHelper logic)
        // For now we simulate login success
        isLoggedIn = true
        await fetchAppIDs()
    }

    func fetchAppIDs() async {
        guard let team = DataManager.shared.model.team,
              let session = DataManager.shared.model.session else {
            statusMessage = "Please login first"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let ids = try await withCheckedThrowingContinuation { continuation in
                AppleAPI().fetchAppIDsForTeam(team: team, session: session) { appIDs, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let appIDs = appIDs {
                        continuation.resume(returning: appIDs)
                    } else {
                        continuation.resume(throwing: NSError(domain: "MoreRAM", code: -1))
                    }
                }
            }
            appIDs = ids.map { AppIDModel(appID: $0) }
            statusMessage = "Loaded \(appIDs.count) App IDs"
        } catch {
            statusMessage = "Failed to fetch App IDs: \(error.localizedDescription)"
        }
    }

    func addIncreasedMemory(to model: AppIDModel) async {
        guard let team = DataManager.shared.model.team,
              let session = DataManager.shared.model.session else { return }

        isLoading = true
        defer { isLoading = false }

        let dateFormatter = ISO8601DateFormatter()
        let headers = [
            "Content-Type": "application/vnd.api+json",
            "User-Agent": "Xcode",
            "Accept": "application/vnd.api+json",
            "Accept-Language": "en-us",
            "X-Apple-App-Info": "com.apple.gs.xcode.auth",
            "X-Xcode-Version": "11.2 (11B41)",
            "X-Apple-I-Identity-Id": session.dsid,
            "X-Apple-GS-Token": session.authToken,
            "X-Apple-I-MD-M": session.anisetteData.machineID,
            "X-Apple-I-MD": session.anisetteData.oneTimePassword,
            "X-Apple-I-MD-LU": session.anisetteData.localUserID,
            "X-Apple-I-MD-RINFO": session.anisetteData.routingInfo.description,
            "X-Mme-Device-Id": session.anisetteData.deviceUniqueIdentifier,
            "X-MMe-Client-Info": session.anisetteData.deviceDescription,
            "X-Apple-I-Client-Time": dateFormatter.string(from: session.anisetteData.date),
            "X-Apple-Locale": session.anisetteData.locale.identifier,
            "X-Apple-I-TimeZone": session.anisetteData.timeZone.abbreviation()!
        ]

        let url = URL(string: "https://developerservices2.apple.com/services/v1/bundleIds/\(model.appID.identifier)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers

        let body = """
        {"data":{"relationships":{"bundleIdCapabilities":{"data":[{"relationships":{"capability":{"data":{"id":"INCREASED_MEMORY_LIMIT","type":"capabilities"}}},"type":"bundleIdCapabilities","attributes":{"settings":[],"enabled":true}}]}},"id":"\(model.appID.identifier)","attributes":{"hasExclusiveManagedCapabilities":false,"teamId":"\(team.identifier)","bundleType":"bundle","identifier":"\(model.appID.bundleIdentifier)","seedId":"\(team.identifier)","name":"\(model.appID.name)"},"type":"bundleIds"}}
        """.data(using: .utf8)

        request.httpBody = body

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            model.result = String(data: data, encoding: .utf8) ?? "Success"
            statusMessage = "Increased Memory Limit added. Re-sign the app."
        } catch {
            statusMessage = "Failed: \(error.localizedDescription)"
        }
    }
}

class AppIDModel: ObservableObject, Identifiable {
    let appID: AppID
    @Published var result: String = ""

    var id: String { appID.identifier }
    var bundleID: String { appID.bundleIdentifier }

    init(appID: AppID) {
        self.appID = appID
    }
}

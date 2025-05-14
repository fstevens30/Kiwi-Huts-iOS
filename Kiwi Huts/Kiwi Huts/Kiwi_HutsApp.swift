import SwiftUI
import PostgREST
import Combine
import CoreLocation
import Supabase

// Define your tab options
enum Tab: String, Identifiable, CaseIterable {
    case home, profile, settings
    var id: String { self.rawValue }
}

// Minimal HutsViewModel for auth-focused flow
class HutsViewModel: ObservableObject {
    @Published var hutsList = [Hut]()
    @Published var lastUpdated: Date?
    
    init() {
        // Fetch huts from the database on initialization
        Task {
            await fetchHuts()
        }
    }
    
    func fetchHuts() async {
        do {
            let huts: [Hut] = try await SupabaseManager.shared.fetchAll(from: "huts")
            DispatchQueue.main.async {
                self.hutsList = huts
                self.lastUpdated = Date()
            }
        } catch {
            print("Error fetching huts: \(error)")
        }
    }
}


@main
struct Kiwi_HutsApp: App {
    @State private var isAuthenticated: Bool = false
    @State private var selectedTab: Tab = .profile
    @StateObject var user = User(completedHuts: [], savedHuts: [])
    @StateObject var viewModel = HutsViewModel()
    private let locationManager = CLLocationManager()
    
    init() {

        requestLocationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isAuthenticated {
                    MainTabView(isAuthenticated: $isAuthenticated)
                        .environmentObject(user)
                        .environmentObject(viewModel)
                        .tint(Color(user.accentColor.assetName))
                } else {
                    AuthView(isAuthenticated: $isAuthenticated)
                        .tint(.accentColorOrange)
                }
            }
            .onAppear {
                Task {
                    await checkLoginStatus()
                }
            }
        }
    }
    
    private func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func checkLoginStatus() async {
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            self.user.id = session.user.id
            isAuthenticated = true
        } catch {
            isAuthenticated = false
            print("No active session or failed to retrieve session: \(error)")
        }
    }
}

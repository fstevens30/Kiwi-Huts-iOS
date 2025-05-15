//
//  User.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 18/03/24.
//

import Foundation
import SwiftUI
import MapKit
import Supabase

enum AccentColor: String, CaseIterable, Codable {
    case orange
    case green
    case yellow
    case pink

    var assetName: String {
        switch self {
        case .orange: return "AccentColorOrange"
        case .green: return "AccentColorGreen"
        case .yellow: return "AccentColorYellow"
        case .pink: return "AccentColorPink"
        }
    }
}

enum MapType: String, CaseIterable, Codable {
    case standard
    case satellite
    case hybrid

    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .satellite: return "Satellite"
        case .hybrid: return "Hybrid"
        }
    }

    // Style for UIKit implementation
    var mkMapType: MKMapType {
        switch self {
        case .standard: return .standard
        case .satellite: return .satellite
        case .hybrid: return .hybrid
        }
    }
    
    // Style for SwiftUI implementation
    var mapStyle: MapStyle {
        switch self {
        case .standard: return .standard
        case .satellite: return .imagery
        case .hybrid: return .hybrid
        }
    }
}
class User: ObservableObject {
    @Published var id: UUID?
    @Published var completedHuts: [Hut]
    @Published var savedHuts: [Hut]
    @Published var accentColor: AccentColor
    @Published var mapType: MapType
    @Published var email: String?
    @Published var username: String?
    @Published var leaderboardRank: Int?
    @Published var leaderboardEntries: [LeaderboardEntry] = []

    struct LeaderboardEntry: Decodable, Identifiable {
        var id: UUID { UUID() }
        let username: String
        let unique_hut_count: Int
    }
    
    init(id: String? = nil, completedHuts: [Hut] = [],
         savedHuts: [Hut] = [],
         accentColor: AccentColor = .orange,
         mapType: MapType = .standard) {
        if let id = id {
            self.id = UUID(uuidString: id)
        } else {
            self.id = UUID()
        }
        self.completedHuts = completedHuts
        self.savedHuts = savedHuts
        self.accentColor = accentColor
        self.mapType = mapType
    }
    
    // Supabase client
    var client = SupabaseManager.shared.client
    
    @MainActor
    func getUsername() async {
        do {
            let response = try await client
                .from("profiles")
                .select("username")
                .eq("id", value: self.id)
                .single()
                .execute()
            
            let raw = response.data
            let decoder = JSONDecoder()
            let data = try decoder.decode([String: String].self, from: raw)
            self.username = data["username"]
            
        } catch {
            print("Error getting username: \(error)")
        }
    }
    
    @MainActor
    func getEmail() async {
        do {
            let response = try await client
                .from("profiles")
                .select("email")
                .eq("id", value: self.id)
                .single()
                .execute()
            
            let raw = response.data
            let decoder = JSONDecoder()
            let data = try decoder.decode([String: String].self, from: raw)
            self.email = data["email"]
        } catch {
            print("Error getting email: \(error)")
        }
    }
    
    func getCompletedHuts() async {
        do {
            let response = try await client
                .from("profiles")
                .select("completedHuts")
                .eq("id", value: self.id)
                .single()
                .execute()
            
            struct CompletedHutsWrapper: Decodable {
                let completedHuts: [Hut]
            }
            
            let raw = response.data
            let decoder = JSONDecoder()
            let wrapper = try decoder.decode(CompletedHutsWrapper.self, from: raw)
            DispatchQueue.main.async {
                self.completedHuts = wrapper.completedHuts
            }
        } catch {
            print("Error getting completed huts: \(error)")
        }
    }
    
    func getSavedHuts() async {
        do {
            let response = try await client
                .from("profiles")
                .select("savedHuts")
                .eq("id", value: self.id)
                .single()
                .execute()

            struct SavedHutsWrapper: Decodable {
                let savedHuts: [Hut]
            }

            let raw = response.data
            let decoder = JSONDecoder()
            let wrapper = try decoder.decode(SavedHutsWrapper.self, from: raw)
            DispatchQueue.main.async {
                self.savedHuts = wrapper.savedHuts
            }
        } catch {
            print("Error getting saved huts: \(error)")
        }
    }
    
    struct UpdateHuts: Encodable {
        var completedHuts: [Hut]
        var savedHuts: [Hut]
    }
    
    func updateHuts() async {
        guard let id = self.id else { return }

        do {
            _ = try await client
                .from("profiles")
                .update(
                    UpdateHuts(completedHuts: self.completedHuts, savedHuts: self.savedHuts))
                .eq("id", value: id)
                .execute()

            print("Successfully updated huts")

        } catch {
            print("Error updating huts: \(error)")
        }
    }
    
    @MainActor
    func getAccentColor() async {
        do {
            let response = try await client
                .from("profiles")
                .select("accentColor")
                .eq("id", value: self.id!)
                .single()
                .execute()

            let raw = response.data
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([String: AccentColor].self, from: raw)
            if let color = decoded["accentColor"] {
                self.accentColor = color
            }

        } catch {
            print("Error getting accent color: \(error)")
        }
    }
    
    func updateAccentColor() async {
        do {
            _ = try await client
                .from("profiles")
                .update(["accentColor": self.accentColor])
                .eq("id", value: self.id!)
                .execute()
            
            print("Successfully updated accent color")
            
        } catch {
            print("Error updating accent color: \(error)")
        }
    }
    
    @MainActor
    func getLeaderboardPosition() async {
        do {
            let response = try await client
                .from("leaderboard")
                .select("*")
                .order("unique_hut_count", ascending: false)
                .execute()

            let raw = response.data
            let decoder = JSONDecoder()
            let entries = try decoder.decode([LeaderboardEntry].self, from: raw)

            self.leaderboardEntries = entries

            // Set rank
            if let username = self.username,
               let rank = entries.firstIndex(where: { $0.username == username }) {
                self.leaderboardRank = rank + 1
            } else {
                self.leaderboardRank = nil
                print("User not found in leaderboard.")
            }

        } catch {
            print("Error getting leaderboard: \(error)")
        }
    }
}

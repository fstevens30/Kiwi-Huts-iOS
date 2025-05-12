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
    @Published var id: String?
    @Published var completedHuts: [Hut]
    @Published var savedHuts: [Hut]
    @Published var accentColor: AccentColor
    @Published var mapType: MapType
    @Published var email: String?
    @Published var username: String?
    
    init(id: String? = nil, completedHuts: [Hut] = [],
         savedHuts: [Hut] = [],
         accentColor: AccentColor = .orange,
         mapType: MapType = .standard) {
        self.id = id
        self.completedHuts = completedHuts
        self.savedHuts = savedHuts
        self.accentColor = accentColor
        self.mapType = mapType
    }
    
    // Supabase client
    var client = SupabaseManager.shared.client
    
    // MARK: - Username
    struct Profile: Decodable {
        let username: String
    }

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
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let data = try decoder.decode(Profile.self, from: raw)
            self.username = data.username
            
        } catch {
            print("Error getting username: \(error)")
        }
    }
    
    //PLACEHOLDER
    func saveData() {
        print("SAVING DATA")
    }
    
}

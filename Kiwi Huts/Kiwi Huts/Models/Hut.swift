import SwiftUI
import MapKit

struct Hut: Identifiable, Codable {
    let id: Int64 // Use "asset_id" as the unique identifier
    let name: String
    let status: String
    let region: String
    let lat: Double
    let lon: Double
    let locationString: String? // Mapped from "location_string"
    let numberOfBunks: Int? // Mapped from "number_of_bunks"
    let facilities: [String]?
    let hutCategory: String? // Mapped from "hut_category"
    let introduction: String
    let introductionThumbnail: String // Mapped from "introduction_thumbnail"
    let staticLink: String // Mapped from "static_link"
    let bookable: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "asset_id"
        case name
        case status
        case region
        case lat
        case lon
        case locationString = "location_string"
        case numberOfBunks = "number_of_bunks"
        case facilities
        case hutCategory = "hut_category"
        case introduction
        case introductionThumbnail = "introduction_thumbnail"
        case staticLink = "static_link"
        case bookable
    }
    
    // Get the sf symbol icon for hut type
    var iconName: String {
        switch hutCategory {
        case "Great Walk":
            return "house.lodge.fill"
        case "Standard", "Serviced":
            return "house.fill"
        case "Basic/bivvies":
            return "tent.fill"
        case "Serviced Alpine":
            return "mountain.2.fill"
        default:
            return "house.fill"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

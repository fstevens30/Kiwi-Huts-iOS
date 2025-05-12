import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient

    private init() {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let url = URL(string: urlString) else {
            fatalError("BASE_URL not found or invalid in Info.plist")
        }
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
    
    func fetchAll<T: Decodable>(from table: String) async throws -> [T] {
        let response: PostgrestResponse<[T]> = try await client
            .from(table)
            .select("*")
            .execute()
        return response.value
    }
}

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var viewModel: HutsViewModel
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        Text("Color Theme")
                        Spacer()
                        Picker("", selection: $user.accentColor) {
                            ForEach(AccentColor.allCases, id: \.self) { color in
                                Text(color.rawValue.capitalized)
                                    .tag(color)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        
                    }
                    HStack {
                        Text("Map Type")
                        Spacer()
                        Picker("", selection: $user.mapType) {
                            ForEach(MapType.allCases, id: \.self) { mapType in
                                Text(mapType.displayName).tag(mapType)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Spacer()
                
                //Logout Button
                Button(action:{} ) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.red.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                if let lastUpdated = viewModel.lastUpdated {
                    Text("Data last updated: \(formatDate(lastUpdated))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Text("No data yet")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(User(accentColor: .yellow, mapType: .standard))
            .environmentObject(HutsViewModel())
    }
}

//
//  MapView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 28/11/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: HutsViewModel
    @EnvironmentObject var user: User
    @State private var selectedHut: Hut? = nil // Track the selected hut
    @State private var hutsFilter: String = "All Huts" // Track the selected filter for huts
    @State private var hutTypeFilter: String = "All Types" // Track the selected filter for hut type

    // Compute the list of huts to display dynamically
    private var selectedHuts: [Hut] {
        let filteredHuts: [Hut]
        switch hutsFilter {
        case "Completed":
            filteredHuts = user.completedHuts
        case "Saved":
            filteredHuts = user.savedHuts
        default:
            filteredHuts = viewModel.hutsList
        }

        if hutTypeFilter == "All Types" {
            return filteredHuts
        } else {
            return filteredHuts.filter { $0.hutCategory == hutTypeFilter }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                
                // Pass dynamically filtered huts and selected map style to MKMapViewWrapper
                MKMapViewWrapper(
                    huts: .constant(selectedHuts), // Dynamically filtered huts
                    selectedHut: $selectedHut,
                    mapType: .constant(user.mapType.mkMapType)
                )
                .edgesIgnoringSafeArea(.top)
                
                VStack {
                    // Dropdown picker for huts selection
                    Menu {
                        Button(action: { hutsFilter = "All Huts" }) {
                            Text("All Huts")
                        }
                        .disabled(hutsFilter == "All Huts")
                        
                        Button(action: { hutsFilter = "Completed" }) {
                            Text("Completed")
                        }
                        .disabled(hutsFilter == "Completed")

                        
                        Button(action: { hutsFilter = "Saved" }) {
                            Text("Saved")
                        }
                        .disabled(hutsFilter == "Saved")

                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(Color(UIColor.systemBackground))
                                .opacity(0.8)
                                .frame(width: 40, height: 40)
                            Image(systemName: "list.bullet")
                                .foregroundStyle(Color.gray)
                                .padding(5)
                        }

                    }
                    
                    
                    // Dropdown picker for hut type selection
                    Menu {
                        Button(action: { hutTypeFilter = "All Types" }) {
                            Text("All Types")
                        }
                        .disabled(hutTypeFilter == "All Types")

                        Button(action: { hutTypeFilter = "Great Walk" }) {
                            Text("Great Walk")
                        }
                        .disabled(hutTypeFilter == "Great Walk")

                        
                        Button(action: { hutTypeFilter = "Standard" }) {
                            Text("Standard")
                        }
                        .disabled(hutTypeFilter == "Standard")
                        
                        Button(action: { hutTypeFilter = "Serviced" }) {
                            Text("Serviced")
                        }
                        .disabled(hutTypeFilter == "Serviced")

                        Button(action: { hutTypeFilter = "Basic/Bivvies" }) {
                            Text("Basic/Bivvies")
                        }
                        .disabled(hutTypeFilter == "Basic/Bivvies")

                        Button(action: { hutTypeFilter = "Serviced Alpine" }) {
                            Text("Serviced Alpine")
                        }
                        .disabled(hutTypeFilter == "Serviced Alpine")

                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(Color(UIColor.systemBackground))
                                .opacity(0.8)
                                .frame(width: 40, height: 40)
                            Image(systemName: "house")
                                .foregroundStyle(Color.gray)
                                .padding(5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                
                // NavigationLink to navigate to HutView
                NavigationLink(
                    destination: selectedHut.map {
                        HutView(hut: $0)
                            .onDisappear { selectedHut = nil } // Reset selectedHut when leaving HutView
                    },
                    isActive: .constant(selectedHut != nil),
                    label: { EmptyView() }
                )
            }
        }
    }

    // Helper function to get map style text
    private func mapStyleText(for mapType: MKMapType) -> String {
        switch mapType {
        case .standard: return "Standard"
        case .satellite: return "Satellite"
        case .hybrid: return "Hybrid"
        default: return "Unknown"
        }
    }
}

struct MapView_Previews : PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(User(accentColor: .orange, mapType: .standard))
            .environmentObject(HutsViewModel())
    }
}

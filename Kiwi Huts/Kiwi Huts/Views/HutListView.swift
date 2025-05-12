//
//  HutListView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 7/03/24.
//

import SwiftUI

struct HutListView: View {
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @EnvironmentObject var user: User
    @EnvironmentObject var viewModel: HutsViewModel
    
    @State private var searchText = ""
    @State private var selectedRegion: String = "All"
    @State private var selectedHutType: String = "All"
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        Picker("Region", selection: $selectedRegion) {
                            Text("All Regions").tag("All")
                            ForEach(uniqueRegions, id: \.self) { region in
                                Text(region).tag(region)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(Color(user.accentColor.assetName))
                        
                        Picker("Hut Type", selection: $selectedHutType) {
                            Text("All Hut Types").tag("All")
                            ForEach(uniqueHutTypes, id: \.self) { hutType in
                                Text(hutType).tag(hutType)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(Color(user.accentColor.assetName))

                    }
                    .padding()

                    List {
                        ForEach(searchResults, id: \.id) { hut in
                            NavigationLink(destination: HutView(hut: hut)) {
                                ListedHutView(hut: hut, showToast: $showToast, toastMessage: $toastMessage)
                            }
                        }
                    }
                }
                .navigationTitle("Huts")
                .searchable(text: $searchText)
                .autocorrectionDisabled(true)
            }
            
            if showToast {
                VStack {
                    Spacer()
                    Toast(message: toastMessage)
                        .transition(.slide)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    var uniqueRegions: [String] {
        Array(Set(viewModel.hutsList.compactMap { $0.region })).sorted()
    }
    
    var uniqueHutTypes: [String] {
        Array(Set(viewModel.hutsList.compactMap { $0.hutCategory })).sorted()
    }
    
    var searchResults: [Hut] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return viewModel.hutsList
            .filter {
                (trimmedSearchText.isEmpty ||
                 $0.name.localizedCaseInsensitiveContains(trimmedSearchText) ||
                 $0.region.localizedCaseInsensitiveContains(trimmedSearchText) ||
                 $0.locationString?.localizedCaseInsensitiveContains(trimmedSearchText) ?? false)
            }
            .filter { selectedRegion == "All" || $0.region == selectedRegion }
            .filter { selectedHutType == "All" || $0.hutCategory == selectedHutType }
            .sorted { $0.name < $1.name }
    }
}

struct HutListView_Preview: PreviewProvider {
    static var previews: some View {
        HutListView()
            .environmentObject(User(accentColor: .orange, mapType: .standard))
            .environmentObject(HutsViewModel())
    }
}

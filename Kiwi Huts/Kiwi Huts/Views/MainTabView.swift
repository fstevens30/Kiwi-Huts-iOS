//
//  NavigationView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 7/03/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var viewModel: HutsViewModel
    @State private var selectedTab = UserDefaults.standard.integer(forKey: "lastTab") // For state restoration
    @Binding var isAuthenticated: Bool

    var body: some View {
        TabView(selection: $selectedTab) {
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(0)
                .environmentObject(viewModel)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.circle.fill")
                }
                .tag(1)
                .environmentObject(viewModel)
            
            HutListView()
                .tabItem {
                    Label("Huts", systemImage: "house.circle.fill")
                }
                .tag(2)
                .environmentObject(viewModel)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(3)
                .environmentObject(viewModel)
                .environmentObject(user)
            
            SettingsView(isAuthenticated: $isAuthenticated)
                .tabItem {
                    Label("Settings", systemImage: "gear.circle.fill")
                }
                .tag(4)
                .environmentObject(viewModel)
                .environmentObject(user)
        }
        .navigationBarBackButtonHidden(true)
        .tint(Color(user.accentColor.assetName))
        .onAppear {
            selectedTab = UserDefaults.standard.integer(forKey: "lastTab") // Restore last selected tab
        }
        .onChange(of: selectedTab) { _ in
            saveTab()
        }
        .onAppear {
            Task {
                await user.getAccentColor()
            }
        }
         
    }

    private func saveTab() {
        UserDefaults.standard.set(selectedTab, forKey: "lastTab")
    }
}

struct MainTabView_Preview: PreviewProvider {
    static var previews: some View {
        MainTabView(isAuthenticated: .constant(true))
            .environmentObject(User(accentColor: .green, mapType: .hybrid))
            .environmentObject(HutsViewModel())
    }
}

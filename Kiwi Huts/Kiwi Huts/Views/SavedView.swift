//
//  ListsView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 7/03/24.
//

import SwiftUI

struct SavedView: View {
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @EnvironmentObject var user: User

    var body: some View {
        VStack {
            
            if user.savedHuts.isEmpty {
                VStack {
                    Text("No huts are saved!")
                        .padding()
                    Text("Use the")
                    Text(Image(systemName: "star.circle"))
                        .font(.title)
                        .foregroundStyle(Color(user.accentColor.assetName))
                    Text("button to save huts here.")
                }
            } else {
                VStack {
                    List(user.savedHuts) { hut in
                        NavigationLink(destination: HutView(hut: hut).environmentObject(user)) {
                            ListedHutView(hut: hut, showToast: $showToast, toastMessage: $toastMessage)
                        }
                    }
                }
            }
            
        }
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await user.getSavedHuts()
            }
        }
    }
}

struct SavedView_Preview: PreviewProvider {
    static var previews: some View {
        SavedView()
            .environmentObject(User(accentColor: .orange, mapType: .standard))
    }
}

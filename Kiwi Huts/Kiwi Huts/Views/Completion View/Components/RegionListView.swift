//
//  RegionListView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 11/04/2024.
//

import SwiftUI

struct RegionListView: View {
    @EnvironmentObject var user: User
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var huts: [Hut]
    var region: String
    
    var body: some View {
        VStack {
            if huts.isEmpty {
                VStack {
                    Text("No huts completed for \(region)!")
                        .padding()
                    Text("Time for an adventure?")
                        .padding()
                }
            } else {
                
                VStack {
                    List(huts) { hut in
                        NavigationLink(destination: HutView(hut: hut)) {
                            ListedHutView(hut: hut, showToast: $showToast, toastMessage: $toastMessage)
                        }
                    }
                }
            }
        }
        .navigationTitle(region)
    }
}

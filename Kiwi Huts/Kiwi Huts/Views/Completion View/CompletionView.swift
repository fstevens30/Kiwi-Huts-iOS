//
//  CompletionView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 7/03/24.
//

import SwiftUI

struct CompletionView: View {
    @EnvironmentObject var viewModel: HutsViewModel
    @EnvironmentObject var user: User
    
    
    // Group huts by region
    var hutsByRegion: [String: [Hut]] {
        Dictionary(grouping: viewModel.hutsList, by: { $0.region })
    }
    
    // Calculate progress for each region
    func progress(for region: String) -> CGFloat {
        let hutsInRegion = hutsByRegion[region] ?? []
        let total = hutsInRegion.count
        guard total > 0 else { return 0 }
        
        let completedCount = hutsInRegion.reduce(0) { (count, hut) in
            return count + (user.completedHuts.contains(where: { $0.id == hut.id }) ? 1 : 0)
        }
        return CGFloat(completedCount) / CGFloat(total)
    }
    
    // Calculate the number of completed huts in each region
    var completedHutsInRegion: [String: Int] {
        hutsByRegion.mapValues { hutsInRegion in
            hutsInRegion.filter { hut in user.completedHuts.contains(where: { $0.id == hut.id }) }.count
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                NavigationLink(destination: RegionListView(huts: user.completedHuts, region: "All Huts").environmentObject(user)) {
                    CircularProgressView(hutCount: Double(user.completedHuts.count), totalHuts: Double(viewModel.hutsList.count))
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                Spacer()
                
                // Sort the regions
                
                let sortedRegions = hutsByRegion.keys.sorted { regionA, regionB in
                    let progressA = progress(for: regionA)
                    let progressB = progress(for: regionB)
                    return progressA > progressB
                }
                
                // Create a regionProgressView for each region
                ForEach(sortedRegions, id: \.self) { region in
                    NavigationLink(destination: RegionListView(huts: viewModel.hutsList.filter { hut in hut.region == region && user.completedHuts.contains(where: { $0.id == hut.id }) }, region: region).environmentObject(user)) {
                        VStack {
                            HStack {
                                Text(region)
                                    .font(.headline)
                                    .foregroundStyle(Color.primary)
                                Spacer()
                                Text("\(completedHutsInRegion[region] ?? 0) / \(hutsByRegion[region]?.count ?? 0)")
                                    .font(.headline)
                                    .foregroundStyle(Color.primary)
                            }
                            RegionProgressView(progress: progress(for: region))
                                .frame(height: 30)
                        }
                        .padding(.horizontal, 50)
                    }
                }
            }
            .navigationTitle("Completion")
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color(user.accentColor.assetName))
        }
        .onAppear {
            Task {
                await user.getCompletedHuts()
            }
        }
    }
}

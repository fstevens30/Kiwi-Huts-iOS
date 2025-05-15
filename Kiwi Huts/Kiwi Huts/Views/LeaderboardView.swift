//
//  LeaderboardView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 15/05/2025.
//

import SwiftUI

struct LeaderboardListView: View {
    @EnvironmentObject var user: User

    var body: some View {
        VStack(alignment: .leading) {
            Text("Leaderboard")
                .font(.headline)
                .padding(.bottom, 4)

            let topTen = Array(user.leaderboardEntries.prefix(10))
            let userInTopTen = topTen.contains { $0.username == user.username }
            let userIndex = user.leaderboardEntries.firstIndex { $0.username == user.username }

            ForEach(topTen.indices, id: \.self) { index in
                let entry = topTen[index]
                HStack {
                    Text("\(index + 1)")
                        .frame(width: 40, alignment: .leading)
                    Text(entry.username)
                        .bold(entry.username == user.username)
                    Spacer()
                    Text("\(entry.unique_hut_count) huts")
                }
                .padding(.vertical, 4)
                .background(entry.username == user.username ? Color(user.accentColor.assetName).opacity(0.3) : Color.clear)
            }

            if !userInTopTen, let userIndex = userIndex {
                Divider()
                let userEntry = user.leaderboardEntries[userIndex]
                HStack {
                    Text("\(userIndex + 1)")
                        .frame(width: 40, alignment: .leading)
                    Text(userEntry.username)
                        .bold()
                    Spacer()
                    Text("\(userEntry.unique_hut_count) huts")
                }
                .padding(.vertical, 4)
                .background(Color(user.accentColor.assetName).opacity(0.3))
            }
        }
        .padding()
        .task {
            await user.getLeaderboardPosition()
        }
    }}

//
//  HutInfoCard.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 26/04/2024.
//

import SwiftUI

struct ToolbarButtons: View {
    @EnvironmentObject var user: User
    let hut: Hut
    
    // Functions for checking save and complete status
    func isHutSaved() -> Bool {
        user.savedHuts.contains(where: { $0.id == hut.id })
    }
    
    func isHutComplete() -> Bool {
        user.completedHuts.contains(where: { $0.id == hut.id })
    }
    
    var body: some View {
        HStack {
            Button {
                Task {
                    await toggleSaved()
                }
            } label: {
                Image(systemName: isHutSaved() ? "star.circle.fill" : "star.circle")
                    .tint(Color(user.accentColor.assetName))
            }
            
            Button {
                Task {
                    await toggleCompleted()
                }
            } label: {
                Image(systemName: isHutComplete() ? "checkmark.circle.fill" : "checkmark.circle")
                    .tint(Color(user.accentColor.assetName))
            }
        }
    }
    
    private func toggleSaved() async {
        if isHutSaved(), let index = user.savedHuts.firstIndex(where: { $0.id == hut.id }) {
            user.savedHuts.remove(at: index)
        } else {
            user.savedHuts.append(hut)
        }
        await user.updateHuts()
    }
    
    private func toggleCompleted() async {
        if isHutComplete(), let index = user.completedHuts.firstIndex(where: { $0.id == hut.id }) {
            user.completedHuts.remove(at: index)
        } else {
            user.completedHuts.append(hut)
        }
        await user.updateHuts()
    }
}


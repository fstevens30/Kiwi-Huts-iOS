//
//  ListedHutView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 18/03/2024.
//

import SwiftUI

struct ListedHutView: View {
    @EnvironmentObject var user: User
    let hut: Hut
    @Binding var showToast: Bool
    @Binding var toastMessage: String

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: hut.introductionThumbnail)) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 75)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .shadow(radius: 5)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .shadow(radius: 5)
                case .failure:
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 75)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .shadow(radius: 5)
                @unknown default:
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 75)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .shadow(radius: 5)
                }
            }
            .padding([.vertical, .horizontal])

            VStack(alignment: .leading) {
                Text(hut.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(hut.region)
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
            }
        }
        .swipeActions(allowsFullSwipe: false) {
            if user.completedHuts.contains(where: { $0.id == hut.id }) {
                Button {
                    user.completedHuts.removeAll(where: { $0.id == hut.id })
                    showToast(message: "\(hut.name) marked as incomplete")
                } label: {
                    Label("Uncomplete", systemImage: "xmark.circle.fill")
                }
                .tint(.red)
            } else {
                Button {
                    user.completedHuts.append(hut)
                    showToast(message: "\(hut.name) marked as complete")
                } label: {
                    Label("Complete", systemImage: "checkmark.circle.fill")
                }
                .tint(.green)
            }
            
            if user.savedHuts.contains(where: { $0.id == hut.id }) {
                Button {
                    user.savedHuts.removeAll(where: { $0.id == hut.id })
                    showToast(message: "\(hut.name) Unsaved")
                } label: {
                    Label("Unsave", systemImage: "star.slash.fill")
                }
                .tint(.red)
            } else {
                Button {
                    user.savedHuts.append(hut)
                    showToast(message: "\(hut.name) saved")
                } label: {
                    Label("Save", systemImage: "star.circle.fill")
                }
                .tint(.yellow)
            }
        }
    }

    private func showToast(message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
    }
}

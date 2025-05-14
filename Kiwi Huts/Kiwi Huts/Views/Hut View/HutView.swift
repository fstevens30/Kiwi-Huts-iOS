//
//  HutView.swift
//  Kiwi Huts
//
//  Created by Flynn Stevens on 6/03/24.
//

import SwiftUI

struct HutView: View {
    @EnvironmentObject var user: User
    let hut: Hut

    var body: some View {

        ScrollView {
            VStack {
                VStack {
                    AsyncImage(url: URL(string: hut.introductionThumbnail)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 200)
                        } else if phase.error != nil {
                            Image(systemName: "house.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200)
                        } else {
                            ProgressView()
                        }
                    }
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .padding()
                        .shadow(radius: 20)
                
                
                    VStack {
                        Text(hut.introduction)
                        
                        if hut.bookable {
                            Link("Book Now", destination: URL(string: hut.staticLink)!)
                                .buttonStyle(.bordered)
                                .padding()
                                .tint(Color(user.accentColor.assetName))
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                HutInfoCardContainer(hut: hut)
                
                Spacer()
                
                
                MapCard(hut: hut).environmentObject(user)
                
            }
        }
        .navigationTitle(hut.name)
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarButtons(hut: hut)
        }
    }
}

struct HutsView_Preview: PreviewProvider {
    static var previews: some View {
        HutView(hut:
                    Hut(id: 1100033374, name: "Luxmore Hut", status: "OPEN", region: "Fiordland", lat: -45.385232, lon: 167.619159, locationString: "Fiordland National Park", numberOfBunks: 54, facilities: ["Cooking","Heating","Mattresses","Lighting","Toilets - flush","Water from tap - not treated, boil before use","Water supply"], hutCategory: "Great Walk", introduction: "This is a 54 bunk, Great Walk hut on the Kepler Track, Fiordland. Bookings are required in all seasons.", introductionThumbnail: "https://www.doc.govt.nz/thumbs/large/link/262b915193334eaba5bd07f74999b664.jpg", staticLink: "https://www.doc.govt.nz/link/dc756fa57891438b8f3fa03813fb7260.aspx", bookable: true)
                )
        .environmentObject(User(completedHuts: [], accentColor: .pink, mapType: .satellite))
    }
}

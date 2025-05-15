import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: HutsViewModel
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    VStack {
                        Text(user.email ?? "Email unavailable.")
                    }
                    Divider()
                    HStack {
                        Spacer()
                        Image(systemName: "house.fill")
                        Text("\(user.completedHuts.count)")
                        Spacer()
                        Image(systemName: "list.number")
                        if user.leaderboardRank != nil {
                            Text("\(user.leaderboardRank!)")
                        } else {
                            Text("N/A")
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                List {
                    NavigationLink(destination: CompletionView().environmentObject(viewModel).environmentObject(user)
                    ) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Completed Huts")
                        }
                    }
                    NavigationLink(destination: SavedView().environmentObject(viewModel).environmentObject(user)){
                        HStack {
                            Image(systemName: "star.circle.fill")
                            Text("Saved Huts")
                        }
                    }
                }
                
                LeaderboardListView(user: _user)
                
                Spacer()
            }
            .navigationTitle(user.username ??  "Profile")
            .task {
                await user.getUsername()
                await user.getEmail()
                await user.getCompletedHuts()
                await user.getSavedHuts()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(User(completedHuts: [], accentColor: .orange, mapType: .standard))
    }
}

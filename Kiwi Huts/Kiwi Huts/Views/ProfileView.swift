import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: User
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    VStack {
                        Text(user.username ?? "Username")
                            .font(.headline)
                    }
                    Divider()
                    HStack {
                        Image(systemName: "house.fill")
                        Text("\(user.completedHuts.count)")
                    }
                }
                
                Spacer()
                
                List {
                    NavigationLink(destination: CompletionView()) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Completed Huts")
                        }
                    }
                    NavigationLink(destination: SavedView()){
                        HStack {
                            Image(systemName: "star.circle.fill")
                            Text("Saved Huts")
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
            .task {
                await user.getUsername()
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

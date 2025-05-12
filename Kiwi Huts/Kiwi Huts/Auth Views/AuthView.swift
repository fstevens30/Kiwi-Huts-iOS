import SwiftUI

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack {
                AppVersionInformationView(
                    versionString: AppVersionProvider.appVersion(),
                    appIcon: AppIconProvider.appIcon()
                )
            }
            
            VStack {
                Text("Kiwi Huts")
                    .font(.headline)
            }
            Divider()
                .padding()
            Spacer()
            VStack {
                NavigationLink(destination: LoginView(isAuthenticated: $isAuthenticated)) {
                    Label("Log In", systemImage: "person.circle.fill")
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.accentColorOrange)
                        .foregroundColor(.accent)
                        .font(.title)
                        .cornerRadius(20)
                }
                .padding(.bottom)
                
                NavigationLink(destination: SignUpView(isAuthenticated: $isAuthenticated)) {
                    Label("Sign Up", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.accentColorOrange)
                        .foregroundColor(.accent)
                        .font(.title)
                        .cornerRadius(20)
                }
            }
            .padding()
            Spacer()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthView(isAuthenticated: .constant(false))
        }
    }
}

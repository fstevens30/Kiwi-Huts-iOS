import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @StateObject private var user = User()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var navigateToProfile: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    NavigationLink(destination: SignUpView(isAuthenticated: $isAuthenticated)) {
                        Text("Sign Up")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .bold()
                    }
                }
                
                Spacer()
                
                Button(action: {
                    login()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 60)
                    } else {
                        Label("Log In", systemImage: "person.circle")
                            .frame(maxWidth: .infinity, minHeight: 60)
                    }
                }
                .disabled(isLoading)
                .background(Color.accentColorOrange)
                .foregroundColor(.accent)
                .font(.title)
                .cornerRadius(20)
                .padding(.horizontal)
                
                
                NavigationLink(
                    destination: MainTabView(isAuthenticated: $isAuthenticated)
                        .environmentObject(user)
                        .environmentObject(HutsViewModel()),
                    isActive: $navigateToProfile
                ) {
                    EmptyView()
                }
                .padding()
            }
            .navigationTitle("Log In")
            .tint(.accentColorOrange)
        }
    }
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and Password are required."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let authResponse = try await SupabaseManager.shared.client.auth.signIn(email: email, password: password)
                
                let authUser = authResponse.user
                user.email = authUser.email ?? email
                user.id = authUser.id
                isAuthenticated = true
                navigateToProfile = true
            } catch {
                errorMessage = "Error logging in: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(isAuthenticated: .constant(false ))
    }
}

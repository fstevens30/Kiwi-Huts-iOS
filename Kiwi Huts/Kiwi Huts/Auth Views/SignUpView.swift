import SwiftUI
import Supabase

struct Profile: Codable {
    let user_id: String
    let username: String
    let email: String
}

struct SignUpView: View {
    @Binding var isAuthenticated: Bool
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @StateObject private var user = User()
    @State private var navigateToProfile: Bool = false

    var body: some View {
        VStack {
                Spacer()
                                
                VStack(spacing: 20) {
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        NavigationLink(destination: LoginView(isAuthenticated: $isAuthenticated)) {
                            Text("Log In")
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .bold()
                        }
                    }
                    
                    Spacer()

                    Button(action: {
                        signUp()
                    }) {
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 60)
                        } else {
                            Label("Go", systemImage: "arrow.right")
                                .frame(maxWidth: .infinity, minHeight: 60)
                        }
                    }
                    .disabled(isLoading)
                    .background(Color.accentColorOrange)
                    .foregroundColor(.accent)
                    .font(.title)
                    .cornerRadius(20)
                    .padding(.horizontal)

                }
            
            NavigationLink(
                destination: MainTabView(isAuthenticated: $isAuthenticated)
                    .environmentObject(user)
                    .environmentObject(HutsViewModel()),
                isActive: $navigateToProfile
            ) {
                EmptyView()
            }
            .padding()
            
            .navigationTitle("Sign Up")
            .tint(.accentColorOrange)
        }
    }

    func signUp() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Sign up user using Supabase auth
                let authResponse = try await SupabaseManager.shared.client.auth.signUp(
                    email: email,
                    password: password,
                    data: ["username": AnyJSON.string(username), "email": AnyJSON.string(email)]
                )

                // Log in user after successful signup
                let loginResponse = try await SupabaseManager.shared.client.auth.signIn(
                    email: email,
                    password: password
                )

                let authUser = loginResponse.user
                user.email = authUser.email ?? email
                user.id = authUser.id
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                isAuthenticated = true
                navigateToProfile = true
            } catch {
                errorMessage = "Error signing up. Please try again. Contact support if the issue persists."
            }
            isLoading = false
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var isAuthenticated = false
    static var previews: some View {
        SignUpView(isAuthenticated: $isAuthenticated)
    }
}

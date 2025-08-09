import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showLogin = false

    var body: some View {
        VStack {
            if let user = authService.currentUser {
                VStack(spacing: 24) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color("AccentColor"))
                        .padding(.top, 40)

                    VStack(spacing: 12) {
                        ProfileDetailRow(iconName: "person.fill", label: "Full Name", value: user.fullname)
                        ProfileDetailRow(iconName: "at", label: "Username", value: user.username)
                        ProfileDetailRow(iconName: "envelope.fill", label: "Email", value: user.email)
                    }
                    .padding(.horizontal)

                    Spacer()

                    Button(action: {
                        Task {
                            try await authService.signOut()
                        }
                    }) {
                        Text("Sign Out")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 20)
                }
            } else {
                VStack(spacing: 20) {
                    Spacer()
                    Text("Log in to manage your profile.")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Button(action: {
                        showLogin.toggle()
                    }) {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showLogin) {
            NavigationView {
                LoginView()
            }
        }
    }
}

struct ProfileDetailRow: View {
    let iconName: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color("AccentColor"))
                .frame(width: 30)
            Text(label)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

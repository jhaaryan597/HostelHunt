import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var username = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.fill.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(Color("AccentColor"))
                .padding(.bottom, 32)

            AuthTextField(imageName: "person.fill", placeholder: "Full Name", text: $fullName)
            AuthTextField(imageName: "at", placeholder: "Username", text: $username)
            AuthTextField(imageName: "envelope.fill", placeholder: "Email", text: $email)
            AuthTextField(imageName: "lock.fill", placeholder: "Password", text: $password, isSecure: true)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                Task {
                    do {
                        try await authService.signUp(withEmail: email, password: password, fullName: fullName, username: username)
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .cornerRadius(10)
            }
            .padding(.top)

            Spacer()

            Button(action: {
                dismiss()
            }) {
                HStack {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color("AccentColor"))
                .font(.footnote)
            }
        }
        .padding(.horizontal, 32)
        .navigationBarHidden(true)
        }
    }
}

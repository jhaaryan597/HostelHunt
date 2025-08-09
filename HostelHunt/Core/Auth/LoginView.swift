import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authService: AuthService

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(Color("AccentColor"))
                .padding(.bottom, 32)

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
                        try await authService.signIn(withEmail: email, password: password)
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .cornerRadius(10)
            }
            .padding(.top)

            Spacer()

            NavigationLink(destination: SignUpView()) {
                HStack {
                    Text("Don't have an account?")
                    Text("Sign up")
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

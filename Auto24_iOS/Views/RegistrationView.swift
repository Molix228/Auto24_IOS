import SwiftUI

struct RegistrationView: View {
    @Binding var isRegistered: Bool
    
    // Info
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(24)
                        .frame(width: 200)
                        .shadow(radius: 4, x: 2, y: 8)
                }
                VStack {
                    Text("Registration")
                        .font(.system(size: 28.0, weight: .semibold))
                        .foregroundStyle(.gray)
                }
                VStack(spacing: 10) {
                    InputView(text: $email, title: "Email", placeholder: "example@mail.com")
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    InputView(text: $username, title: "Username", placeholder: "Enter your username")
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecuredField: true)
                }
                .padding(.horizontal, 30)
                .padding(.top, 24)

                if !errorText.isEmpty {
                    Text(errorText)
                        .foregroundColor(.red)
                }
                
                Button {
                    if validateData() {
                        registerUser()
                    }
                } label: {
                    HStack {
                        Text("Create Account")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 64, height: 48)
                }
                .background(.blue)
                .clipShape(Capsule())
                .padding(.vertical, 24)
                
                NavigationLink(destination: LoginView(isEntered: .constant(false)), label: {
                    HStack(spacing: 3) {
                        Text("Do you have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 18))
                    .foregroundStyle(.blue)
                })
                .padding()
            }
            .background(.tertiary)
            .clipShape(.rect(cornerRadius: 20))
            .padding()
        }
    }

    private func validateData() -> Bool {
        // Email validation
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        guard NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: email) else {
            errorText = "Please enter a valid email address."
            return false
        }

        // Password validation
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasUpper = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        guard password.count >= 8, hasNumbers, hasUpper else {
            errorText = "Password must be at least 8 characters, include a number and an uppercase letter."
            return false
        }
        
        // Clear error text if all validations pass
        errorText = ""
        return true
    }

    private func registerUser() {
        let url = URL(string: "https://auto24-api.com/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData = [
            "email": email,
            "username": username,
            "password": password,
            "role": "User"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData, options: [])
        } catch {
            print("Error: cannot create JSON from userData")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response from server: \(responseString)")
                }
                DispatchQueue.main.async {
                    self.isRegistered = true
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
}

#Preview {
    RegistrationView(isRegistered: .constant(false))
}

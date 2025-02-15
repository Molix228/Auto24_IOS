import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: LoginInFocus?

    enum LoginInFocus: Int, Hashable {
        case username, password
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .shadow(radius: 4, x: 2, y: 8)
                        .padding()

                    Text("Login")
                        .font(.system(size: 28.0, weight: .semibold))
                        .foregroundStyle(.gray)

                    Group {
                        InputView(text: $username, title: "Username", placeholder: "Enter your username")
                            .focused($focusedField, equals: .username)
                            .keyboardType(.default)

                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecuredField: true)
                            .focused($focusedField, equals: .password)
                            .keyboardType(.default)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 24)

                    Button(action: {
                        loginUser()
                    }) {
                        HStack {
                            Text("Login")
                                .fontWeight(.semibold)
                            Image(systemName: "return")
                        }
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width - 64, height: 48)
                        .background(.blue)
                        .clipShape(.capsule)
                        .padding(.vertical, 24)
                    }
                }
                .background(Color.gray.opacity(0.2))
                .clipShape(.rect(cornerRadius: 20))
                .padding()
                .onAppear {
                    focusedField = .username
                }
            }
        }
    }

    private func loginUser() {
        print("✅ Кнопка Login нажата!")

        let url = URL(string: "https://auto24-api.com/users/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginData = [
            "username": username,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData, options: [])
        } catch {
            print("❌ Ошибка: не удалось создать JSON")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("🔹 Ответ от сервера: \(httpResponse.statusCode)")
                guard let data = data else {
                    print("❌ Пустой ответ от сервера")
                    return
                }

                if httpResponse.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = json["token"] as? String {
                            DispatchQueue.main.async {
                                authViewModel.loginSuccess(token: token)
                            }
                        }
                    } catch {
                        print("❌ Ошибка парсинга JSON: \(error)")
                    }
                } else {
                    print("❌ Ошибка входа. Статус: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}

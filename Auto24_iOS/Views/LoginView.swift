import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Binding var isEntered: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Image("icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .shadow(radius: 4, x: 2, y: 8)
                            .padding()
                    }
                    VStack {
                        Text("Login")
                            .font(.system(size: 28.0, weight: .semibold))
                            .foregroundStyle(.gray)
                    }
                    VStack(spacing: 10) {
                        InputView(text: $username, title: "Username", placeholder: "Enter your username")
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecuredField: true)
                    }
                    .keyboardType(.default)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
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
                    }
                    .background(.blue)
                    .clipShape(.capsule)
                    .padding(.vertical, 24)
                }
                .background(Color.gray.opacity(0.2))
                .clipShape(.rect(cornerRadius: 20))
                .padding()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }

    func loginUser() {
        print("✅ Кнопка Login нажата!")

        let url = URL(string: "https://auto24-api.com/users/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginData = [
            "username": username,
            "password": password
        ]

        let config = URLSessionConfiguration.default
        config.httpCookieAcceptPolicy = .always
        config.httpShouldSetCookies = true
        let session = URLSession(configuration: config)

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData, options: [])
        } catch {
            print("❌ Ошибка: не удалось создать JSON")
        }

        session.dataTask(with: request) { data, response, error in
            print("📡 Отправлен запрос на сервер")
            if let httpResponse = response as? HTTPURLResponse {
                print("🔹 Получен ответ от сервера: \(httpResponse.statusCode)")

                guard let data = data else {
                    print("❌ Ошибка: пустой ответ от сервера")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        
                        print("🔹 Получен токен: \(token)")
                        KeychainHelper.saveToken(token) // ✅ Сохраняем токен в Keychain

                        DispatchQueue.main.async {
                            self.isEntered = true
                            print("✅ Авторизация успешна, isEntered = \(self.isEntered)")
                        }
                    } else {
                        print("❌ Ошибка: Токен не найден в ответе сервера")
                    }
                } catch {
                    print("❌ Ошибка парсинга JSON: \(error)")
                }
            } else if let error = error {
                print("❌ HTTP запрос не удался: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    LoginView(isEntered: .constant(false))
}

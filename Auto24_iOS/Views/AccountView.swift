import SwiftUI

struct AccountView: View {
    @Binding var isRegistered: Bool
    @Binding var isEntered: Bool

    init(isRegistered: Binding<Bool>, isEntered: Binding<Bool>) {
        self._isRegistered = isRegistered
        self._isEntered = isEntered
    }

    var body: some View {
        VStack {
            if isEntered {
                ExpandedAccountView()
            } else if isRegistered {
                LoginView(isEntered: $isEntered)
            } else {
                RegistrationView(isRegistered: $isRegistered)
            }
        }
        .onAppear {
            checkAuthStatus() // ✅ Проверяем аутентификацию при открытии экрана
        }
    }

    private func checkAuthStatus() {
        if let token = KeychainHelper.getToken(), !token.isEmpty {
            DispatchQueue.main.async {
                self.isEntered = true
                print("✅ Пользователь авторизован через токен в Keychain")
            }
        } else {
            DispatchQueue.main.async {
                self.isEntered = false
                print("❌ Токен отсутствует в Keychain, авторизация не выполнена")
            }
        }
    }
}

#Preview {
    AccountView(isRegistered: .constant(false), isEntered: .constant(false))
}

import SwiftUI

struct AccountView: View {
    @Binding var isRegistered: Bool
    @Binding var isEntered: Bool

    init(isRegistered: Binding<Bool>, isEntered: Binding<Bool>) {
        self._isRegistered = isRegistered
        self._isEntered = isEntered
        self._isEntered.wrappedValue = UserDefaults.standard.bool(forKey: "isEntered") // ✅ Загружаем сохранённое значение
    }

    var body: some View {
        if isEntered {
            ExpandedAccountView()
        } else if isRegistered {
            LoginView(isEntered: $isEntered)
        } else {
            RegistrationView(isRegistered: $isRegistered)
        }
    }
}

#Preview {
    AccountView(isRegistered: .constant(false), isEntered: .constant(false))
}

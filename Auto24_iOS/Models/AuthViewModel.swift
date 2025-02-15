//
//  AuthViewModel.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 15.02.2025.
//


import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false

    init() {
        checkAuthStatus()
    }

    func checkAuthStatus() {
        if let token = KeychainHelper.getToken(), !token.isEmpty {
            isLoggedIn = true
            print("✅ Пользователь авторизован через токен в Keychain")
        } else {
            isLoggedIn = false
            print("❌ Токен отсутствует в Keychain")
        }
    }

    func loginSuccess(token: String) {
        KeychainHelper.saveToken(token)
        isLoggedIn = true
        print("✅ Авторизация прошла успешно!")
    }

    func registerSuccess() {
        isRegistered = true
        print("✅ Регистрация прошла успешно!")
    }

    func logout() {
        KeychainHelper.deleteToken()
        isLoggedIn = false
        print("🚪 Пользователь вышел из аккаунта")
    }
}

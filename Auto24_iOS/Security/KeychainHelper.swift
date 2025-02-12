//
//  KeychainHelper.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 13.02.2025.
//

import Security
import Foundation

class KeychainHelper {
    static let service = "com.auto24.app"

    // ✅ Сохранение токена в Keychain
    static func saveToken(_ token: String) {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "userToken",
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary) // Удаляем старый токен перед записью
        SecItemAdd(query as CFDictionary, nil)
    }

    // ✅ Получение токена
    static func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "userToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    // ❌ Удаление токена (при логауте)
    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "userToken"
        ]
        SecItemDelete(query as CFDictionary)
    }
}

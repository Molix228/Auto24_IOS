//
//  ExpandedAccountView.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 12.02.2025.
//

import SwiftUI

struct ExpandedAccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var user: UserResponse?
    
    var body: some View {
        VStack {
            if let user = user {
                Text("Welcome, \(user.username)!")
                    .font(.title)
                    .padding(.bottom, 10)
                
                Text("Email: \(user.email)")
                    .foregroundColor(.gray)
                
                if let profileImage = user.profileImage {
                    AsyncImage(url: URL(string: profileImage.path)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.top, 10)
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            fetchUserData()
        }
    }

    func fetchUserData() {
        guard let token = KeychainHelper.getToken() else {
            print("⚠️ No token found in Keychain")
            return
        }

        let url = URL(string: "https://auto24-api.com/users/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // ✅ Добавляем токен в заголовок

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                print("🔒 Unauthorized - Token may be invalid or expired")
                return
            }

            if let data = data {
                do {
                    let decodedUser = try JSONDecoder().decode(UserResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.user = decodedUser
                    }
                } catch {
                    print("⚠️ Error decoding user data: \(error)")
                }
            }
        }.resume()
    }
}

#Preview {
    ExpandedAccountView()
}

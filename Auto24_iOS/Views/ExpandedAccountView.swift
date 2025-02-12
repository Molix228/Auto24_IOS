//
//  ExpandedAccountView.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 12.02.2025.
//

import SwiftUI

struct ExpandedAccountView: View {
    @State private var user: UserResponse?
    
    var body: some View {
        VStack {
            if let user = user {
                Text("Welcome, \(user.username)!")
                Text("Email: \(user.email)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            fetchUserData()
        }
    }

    func fetchUserData() {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            print("⚠️ userID not found in UserDefaults")
            return
        }
        
        let url = URL(string: "https://auto24-api.com/users/\(userID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
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

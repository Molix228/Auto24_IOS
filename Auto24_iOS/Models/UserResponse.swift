//
//  UserResponse.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 12.02.2025.
//

import Foundation

struct UserResponse: Identifiable, Decodable {
    var id: String
    var username: String
    var email: String
    var profileImage: UserImageResponse?
    var role: String
}

struct UserImageResponse: Decodable {
    var path: String
}

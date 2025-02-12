//
//  ItemResponse.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 10.02.2025.
//

import Foundation

struct ItemResponse: Identifiable, Decodable {
    let id: String
    let make: String
    let model: String
    let price: Int
    let year: Int
    let mileage: Int?
    let images: [ImageResponse]
}

struct ImageResponse: Decodable {
    let path: String
}

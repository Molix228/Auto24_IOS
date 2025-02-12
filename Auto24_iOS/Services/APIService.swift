import Foundation

@MainActor
class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://auto24-api.com"
    
    func fetchUserData() async throws -> UserResponse {
        let url = URL(string: "\(baseURL)/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UserResponse.self, from: data)
    }
    
    // MARK: SearchFunction
    func searchItems(
        make: String? = nil,
        model: String? = nil,
        year: Int? = nil,
        price: Int? = nil,
        minMileage: Int? = nil,
        maxMileage: Int? = nil
    ) async throws -> [ItemResponse] {
        var queryItems: [URLQueryItem] = []
        
        if let make = make, !make.isEmpty { queryItems.append(URLQueryItem(name: "make", value: make)) }
        if let model = model, !model.isEmpty { queryItems.append(URLQueryItem(name: "model", value: model))}
        if let year = year { queryItems.append(URLQueryItem(name: "year", value: "\(year)")) }
        if let price = price { queryItems.append(URLQueryItem(name: "price", value: "\(price)"))}
        if let minMileage = minMileage, minMileage > 0 { queryItems.append(URLQueryItem(name:"minMileage",value: "\(minMileage)")) }
        if let maxMileage = maxMileage, maxMileage > 0 { queryItems.append(URLQueryItem(name:"maxMileage",value: "\(maxMileage)")) }
        var urlComponents = URLComponents(string: "\(baseURL)/items/search")
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([ItemResponse].self, from: data)
    }

    
    // MARK: Get Items
    func fetchItems() async throws -> [ItemResponse] {
        guard let url = URL(string: "\(baseURL)/items") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([ItemResponse].self, from: data)
    }
}

//
//  ContentViewModel.swift
//  SwiftUI-Network-Call
//
//  Created by Caner Çağrı on 6.07.2023.
//

import SwiftUI

class UserManager {
    
    static let shared = UserManager()
    
    func getUser() async throws -> GitHubUser {
        
        let endpoint = "https://api.github.com/users/canercagri"
        
        guard let url = URL(string: endpoint) else {
            throw GHNetworkError.invalidURL
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHNetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHNetworkError.invalidData
        }
    }
}

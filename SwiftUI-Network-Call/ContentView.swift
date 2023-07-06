//
//  ContentView.swift
//  SwiftUI-Network-Call
//
//  Created by Caner Çağrı on 6.07.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var user: GitHubUser?
    
    var body: some View {
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.gray)
            }
            .frame(width: 120, height: 120, alignment: .center)
            

            
            Text(user?.login ?? "User Placeholder")
                .bold()
                .font(.title3)
            
            Text(user?.bio ?? "This area for bio, from GithubAPI, so when we fetch data bio will show up here.")
                .padding()
            
            Spacer()
            
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            } catch GHNetworkError.invalidData {
                print("Invalid Data")
            } catch GHNetworkError.invalidResponse {
                print("Invalid Response")
            } catch GHNetworkError.invalidURL {
                print("Invalid Url")
            } catch {
                print("Unexpected Error")
            }
        }
    }
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GitHubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GHNetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

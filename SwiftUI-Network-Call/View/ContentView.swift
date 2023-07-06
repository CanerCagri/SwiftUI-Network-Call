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
                user = try await UserManager.shared.getUser()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

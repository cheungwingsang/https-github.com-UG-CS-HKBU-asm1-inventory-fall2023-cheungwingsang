//
//  GamesListView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//

import SwiftUI

struct GamesListView: View {
    @State private var games: [Game] = []
    
    var body: some View {
        //NavigationView {
            List(games) { game in
                NavigationLink(destination: GameDetailView(game: game)) {
                    VStack(alignment: .leading) {
                        Text(game.title)
                            .font(.headline)
                        
                        Text(game.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        //}
        .navigationTitle("Games")
        .onAppear {
            fetchGames()
        }
    }
    
    func fetchGames() {
        guard let url = URL(string: "https://comp4107.azurewebsites.net/inventory?type=game") else {
            // Handle invalid URL
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle error
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let fetchedGames = try decoder.decode([Game].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.games = fetchedGames
                    }
                } catch let decodingError {
                    // Handle decoding error
                    print("Error decoding games data: \(decodingError.localizedDescription)")
                    print("Data: \(String(data: data, encoding: .utf8) ?? "")")
                    print("Response: \(response)")
                }
            }
        }.resume()
    }
}

struct Game: Codable, Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    let quantity: Int
    let description: String
    let category: String
    let publisher: String
    let location: String
    let remark: String
    let type: String
    let borrower: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl = "image"
        case quantity
        case description
        case category
        case publisher
        case location
        case remark
        case type
        case borrower
    }
}

struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView()
    }
}

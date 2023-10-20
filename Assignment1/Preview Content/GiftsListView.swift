//
//  GiftsListView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//

import SwiftUI

struct GiftsListView: View {
    @State private var gifts: [Gift] = []
    
    var body: some View {
        //NavigationView {
            List(gifts) { gift in
                NavigationLink(destination: GiftDetailView(gift: gift)) {
                    VStack(alignment: .leading) {
                        Text(gift.title)
                            .font(.headline)
                        
                        Text(gift.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        //}
        .navigationTitle("Gifts")
        .onAppear {
            fetchGifts()
        }
    }
    
    func fetchGifts() {
        guard let url = URL(string: "https://comp4107.azurewebsites.net/inventory?type=gift") else {
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
                    let fetchedGifts = try decoder.decode([Gift].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.gifts = fetchedGifts
                    }
                } catch let decodingError {
                    // Handle decoding error
                    print("Error decoding gifts data: \(decodingError.localizedDescription)")
                    print("Data: \(String(data: data, encoding: .utf8) ?? "")")
                    print("Response: \(response)")
                }
            }
        }.resume()
    }
}

struct Gift: Codable, Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    let donatedBy: String
    let description: String
    let category: String
    let amount: Int
    let unitPrice: Int
    let location: String
    let remark: String
    let type: String
    let remaining: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl = "image"
        case donatedBy
        case description
        case category
        case amount
        case unitPrice
        case location
        case remark
        case type
        case remaining
    }
}

struct GiftsListView_Previews: PreviewProvider {
    static var previews: some View {
        GiftsListView()
    }
}

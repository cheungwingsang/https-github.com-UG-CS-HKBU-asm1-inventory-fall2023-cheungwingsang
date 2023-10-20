//
//  SearchBoxView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//

import SwiftUI

struct SearchResult: Codable {
    let id: String
    let title: String
    let image: String
    let description: String
    let category: String
    let publisher: String?
    let location: String
    let remark: String
    let type: String
    let borrower: String?
    let author: String?
    let year: String?
    let isbn: String?
    let donatedBy: String?
    let amount: Int?
    let unitPrice: Int?
    let remaining: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case image
        case description
        case category
        case publisher
        case location
        case remark
        case type
        case borrower
        case author
        case year
        case isbn
        case donatedBy
        case amount
        case unitPrice
        case remaining
    }
}

struct SearchBoxView: View {
    @Binding var searchText: String
    @Binding var searchResults: [SearchResult]
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter keyword or ID", text: $searchText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    //.padding(.top,10)
                
                Button(action: {
                    performSearch()
                }) {
                    Text("Search")
                        .padding()
                        .frame(width: 330, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                List(searchResults, id: \.id) { result in
                    VStack(alignment: .leading) {
                        Text("Title: \(result.title)")
                        Text("Type: \(result.type)")
                        Text("Author: \(result.author ?? "")")
                        Text("Year: \(result.year ?? "")")
                        
                        // Display more properties as needed
                    }
                }
            }
            .padding()
            .navigationBarTitle("Search")
            
        }
    }
    
    private func performSearch() {
        if isValidId(searchText) {
            searchById(id: searchText)
        } else {
            searchByKeyword(keyword: searchText)
        }
    }
    
    private func searchById(id: String) {
        guard let url = URL(string: "https://comp4107.azurewebsites.net/inventory/\(id)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    DispatchQueue.main.async {
                        searchResults = [searchResult]
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    private func searchByKeyword(keyword: String) {
        guard var urlComponents = URLComponents(string: "https://comp4107.azurewebsites.net/inventory") else {
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "keyword", value: keyword)]
        
        guard let url = urlComponents.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let searchResults = try JSONDecoder().decode([SearchResult].self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = searchResults
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    private func isValidId(_ input: String) -> Bool {
        let idRegex = "^[a-fA-F0-9]{24}$"
        let idPredicate = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return idPredicate.evaluate(with: input)
    }
}


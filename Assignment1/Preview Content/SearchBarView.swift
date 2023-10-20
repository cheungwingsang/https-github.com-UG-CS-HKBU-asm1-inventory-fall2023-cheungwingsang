//
//  SearchBarView.swift
//  Assignment1
//
//  Created by Leo Cheung on 19/10/2023.
//

import SwiftUI

struct SearchResult2: Codable, Hashable {
    let id: String
    let title: String
    let image: String
    let description: String
    let category: String
    let location: String
    let remark: String
    let type: String
    let publisher: String?
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

struct SearchBarView: View {
    @State private var searchText = ""
    @State private var searchResults: [SearchResult2] = []
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            List(searchResults, id: \.self) { result in
                NavigationLink(destination: SearchDetailView(searchResult: result)) {
                    VStack(alignment: .leading) {
                        Text("Title: " + result.title)
                            .font(.headline)
                        Text("Type: " + result.type)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .searchable(text: $searchText) {
                ForEach(searchResults, id: \.self) { result in
                    Text(result.title).searchCompletion(result.title)
                }
            }
            .navigationTitle("Search")
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                    } else if searchResults.isEmpty {
                        Text("No results found")
                            .foregroundColor(.gray)
                    }
                }
            )
        }
        .onSubmit(of: .search) {
            performSearch()
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
        isLoading = true

        guard let url = URL(string: "https://comp4107.azurewebsites.net/inventory/\(id)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer {
                isLoading = false
            }

            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult2.self, from: data)
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
        isLoading = true

        guard var urlComponents = URLComponents(string: "https://comp4107.azurewebsites.net/inventory") else {
            return
        }

        urlComponents.queryItems = [URLQueryItem(name: "keyword", value: keyword)]

        guard let url = urlComponents.url else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer {
                isLoading = false
            }

            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let searchResults = try JSONDecoder().decode([SearchResult2].self, from: data)
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


struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}

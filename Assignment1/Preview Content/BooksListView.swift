//
//  BooksListView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//

import SwiftUI

struct BooksListView: View {
    @State private var books: [Book] = []
    
    var body: some View {
        //NavigationView {
            List(books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        
                        Text(book.author)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        //}
        .navigationTitle("Books")
        .onAppear {
            fetchBooks()
        }
    }
    
    func fetchBooks() {
        guard let url = URL(string: "https://comp4107.azurewebsites.net/inventory?type=book") else {
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
                    let fetchedBooks = try decoder.decode([Book].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.books = fetchedBooks
                    }
                } catch let decodingError {
                    // Handle decoding error
                    print("Error decoding books data: \(decodingError.localizedDescription)")
                    print("Data: \(String(data: data, encoding: .utf8) ?? "")")
                    print("Response: \(response)")
                }
            }
        }.resume()
    }
}

struct Book: Codable, Identifiable {
    let id: String
    let title: String
    let author: String
    let year: String
    let isbn: String
    let description: String
    let category: String
    let publisher: String
    let location: String
    let imageUrl: String?
    let remark: String
    let type: String
    let borrower: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case author
        case year
        case isbn
        case description
        case category
        case publisher
        case location
        case imageUrl = "image"
        case remark
        case type
        case borrower
    }
}

struct BooksListView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListView()
    }
}

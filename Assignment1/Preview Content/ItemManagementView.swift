//
//  ItemManagementView.swift
//  Assignment1
//
//  Created by Leo Cheung on 11/10/2023.
//
import SwiftUI

struct Item: Codable, Hashable {
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

struct ItemManagementView: View {
    @State private var selectedItem = 0
    @Binding var loggedIn: Bool
    @State private var borrowedItems: [Item] = []
    @State private var consumedItems: [Item] = []
    //let token: String
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Records")
                        .font(.title)
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        loggedIn = false
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .cornerRadius(15.0)
                    }
                    .padding(.trailing, 10)
                }
                
                Picker("", selection: $selectedItem) {
                    Text("Borrowed").tag(0)
                    Text("Consumed").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Spacer()
                
                // Display a list view based on the selected segment
                if selectedItem == 0 {
                    BorrowedItemsListView(borrowedItems: borrowedItems)
                        .onAppear {
                            fetchBorrowedItems()
                        }
                } else {
                    ConsumedItemsListView(consumedItems: consumedItems)
                        .onAppear {
                            fetchConsumedItems()
                        }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func fetchBorrowedItems() {
        guard let url = URL(string: "https://comp4107.azurewebsites.net/user/borrowed") else {
            return
        }
        
        //var request = URLRequest(url: url)
        //request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //URLSession.shared.dataTask(with: request) { data, response, error in
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let borrowedItems = try decoder.decode([Item].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.borrowedItems = borrowedItems
                    }
                } catch {
                    print("Error decoding borrowed items: \(error)")
                }
            }
        }.resume()
    }


    private func fetchConsumedItems() {
        guard let url = URL(string: "https://comp4107.azurewebsites.net/user/consumed") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let consumedItems = try decoder.decode([Item].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.consumedItems = consumedItems
                    }
                } catch {
                    print("Error decoding consumed items: \(error)")
                }
            }
        }.resume()
    }
    
    
    struct BorrowedItemsListView: View {
        var borrowedItems: [Item]

        var body: some View {
            List(borrowedItems, id: \.self) { item in
                Text(item.title)
            }
        }
    }

    struct ConsumedItemsListView: View {
        var consumedItems: [Item]

        var body: some View {
            List(consumedItems, id: \.self) { item in
                Text(item.title)
            }
        }
    }
}

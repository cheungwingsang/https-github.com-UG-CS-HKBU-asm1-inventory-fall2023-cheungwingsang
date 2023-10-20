//
//  GameDetailView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//

import SwiftUI

struct GameDetailView: View {
    let game: Game
    @State private var imageData: Data? = nil
    @State private var showAlert = false
    @State private var isLoggedIn = false 
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("Title: \(game.title)")
                Text("Quantity: \(game.quantity)")
                Text("Description: \(game.description)")
                Text("Category: \(game.category)")
                Text("Publisher: \(game.publisher)")
                Text("Location: \(game.location)")
            }
            
            Section(header: Text("Additional Information")) {
                if let url = URL(string: game.imageUrl) {
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onAppear {
                                URLSession.shared.dataTask(with: url) { data, _, _ in
                                    if let data = data {
                                        DispatchQueue.main.async {
                                            self.imageData = data
                                        }
                                    }
                                }.resume()
                            }
                    }
                } else {
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Text("Remark: \(game.remark)")
                Text("Type: \(game.type)")
                
                if game.borrower != "none" {
                    Text("Borrower: \(game.borrower)")
                }
            }
        }
        .navigationBarItems(
                    trailing: Button(action: {
                        if isLoggedIn {
                            borrowItem()
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Borrow")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                )
                .navigationTitle("Game Detail")
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Required"),
                        message: Text("Please log in to borrow this item."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            
            private func borrowItem() {
                guard let userId = getUserId() else {
                    // Handle the case where the user ID is not available
                    return
                }
                
                let borrowURL = URL(string: "https://comp4107.azurewebsites.net/user/borrow/\(userId)")!
                
                // Perform the API call to borrow the item using borrowURL
                // ...
            }
            
            private func getUserId() -> String? {
                // Add your logic to retrieve the user ID
                // Return the user ID if available, or nil if not logged in
                return isLoggedIn ? "641beb90fc13ae2cf0000494" : nil
            }
        }

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let game = Game(
            id: "1",
            title: "Sample Game",
            imageUrl: "http://dummyimage.com/246x100.png/5fa2dd/ffffff",
            quantity: 6,
            description: "Sample description",
            category: "Toys",
            publisher: "Sample Publisher",
            location: "Sample Location",
            remark: "Sample Remark",
            type: "game",
            borrower: "none"
        )
        return GameDetailView(game: game)
    }
}

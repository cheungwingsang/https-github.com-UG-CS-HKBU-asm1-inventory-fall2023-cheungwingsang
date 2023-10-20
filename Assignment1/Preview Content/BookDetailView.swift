//
//  BookDetailView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//
import SwiftUI

struct BookDetailView: View {
    let book: Book
    @State private var imageData: Data? = nil
    @State private var showAlert = false
    @State private var isLoggedIn = false 
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("Title: \(book.title)")
                Text("Author: \(book.author)")
                Text("Year: \(book.year)")
                Text("ISBN: \(book.isbn)")
                Text("Description: \(book.description)")
                Text("Category: \(book.category)")
                Text("Publisher: \(book.publisher)")
                Text("Location: \(book.location)")
            }
            
            Section(header: Text("Additional Information")) {
                if let imageUrl = book.imageUrl,
                   let url = URL(string: imageUrl) {
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "book")
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
                    Image(systemName: "book")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Text("Remark: \(book.remark)")
                Text("Type: \(book.type)")
                
                if let borrower = book.borrower {
                    Text("Borrower: \(borrower)")
                }
            }
        }
        .navigationBarItems(
                    trailing: Button(action: {
                        if isLoggedIn {
                            
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
                .navigationTitle("Book Detail")
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Required"),
                        message: Text("Please log in to borrow this item."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
    }


struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let book = Book(
            id: "1",
            title: "Sample Book",
            author: "John Doe",
            year: "2023",
            isbn: "1234567890",
            description: "Sample description",
            category: "Fiction",
            publisher: "Sample Publisher",
            location: "Sample Location",
            imageUrl: nil,
            remark: "Sample Remark",
            type: "Sample Type",
            borrower: nil
        )
        return BookDetailView(book: book)
    }
}

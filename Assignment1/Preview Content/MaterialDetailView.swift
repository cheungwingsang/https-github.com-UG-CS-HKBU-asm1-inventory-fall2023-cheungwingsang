//
//  MaterialDetailView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//

import SwiftUI

struct MaterialDetailView: View {
    let material: Material
    @State private var imageData: Data? = nil
    @State private var showAlert = false
    @State private var isLoggedIn = false
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("Title: \(material.title)")
                Text("Description: \(material.description)")
                Text("Category: \(material.category)")
                Text("Quantity: \(material.quantity)")
                Text("Location: \(material.location)")
            }
            
            Section(header: Text("Additional Information")) {
                if let imageUrl = URL(string: material.imageUrl) {
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "list.bullet.rectangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onAppear {
                                URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                                    if let data = data {
                                        DispatchQueue.main.async {
                                            self.imageData = data
                                        }
                                    }
                                }.resume()
                            }
                    }
                } else {
                    Image(systemName: "list.bullet.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Text("Remark: \(material.remark)")
                Text("Type: \(material.type)")
                
                if let remaining = material.remaining {
                    Text("Remaining: \(remaining)")
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
                Text("Consume")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        )
        .navigationTitle("Material Detail")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Required"),
                message: Text("Please log in to borrow this item."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

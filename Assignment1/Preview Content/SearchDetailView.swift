//
//  SearchDetailView.swift
//  Assignment1
//
//  Created by Leo Cheung on 19/10/2023.
//

import SwiftUI






struct SearchDetailView: View {
    let searchResult: SearchResult2
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Text("Title:")
                    .font(.headline)
                Text(searchResult.title)
            }
            
            Group {
                Text("Type:")
                    .font(.headline)
                Text(searchResult.type)
            }
            
            Group {
                Text("Description:")
                    .font(.headline)
                Text(searchResult.description)
            }
            
            Group {
                Text("Category:")
                    .font(.headline)
                Text(searchResult.category)
            }
            
            Group {
                Text("Location:")
                    .font(.headline)
                Text(searchResult.location)
            }
            
            Group {
                Text("Remark:")
                    .font(.headline)
                Text(searchResult.remark)
            }
            
            Group {
                Text("Image:")
                    .font(.headline)
                
                if let url = URL(string: searchResult.image) {
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "magnifyingglass.circle")
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
                    Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
        .padding()
        .navigationTitle("Search Result Detail")
    }
    
}

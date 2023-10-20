//
//  MaterialsListView.swift
//  Assignment1
//
//  Created by Leo Cheung on 10/10/2023.
//

import SwiftUI

struct MaterialsListView: View {
    @State private var materials: [Material] = []
    
    var body: some View {
        //NavigationView {
            List(materials) { material in
                NavigationLink(destination: MaterialDetailView(material: material)) {
                    VStack(alignment: .leading) {
                        Text(material.title)
                            .font(.headline)
                        
                        Text(material.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        //}
        .navigationTitle("Materials")
        .onAppear {
            fetchMaterials()
        }
    }
    
    func fetchMaterials() {
        guard let url = URL(string: "https://comp4107.azurewebsites.net/inventory?type=material") else {
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
                    let fetchedMaterials = try decoder.decode([Material].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.materials = fetchedMaterials
                    }
                } catch let decodingError {
                    // Handle decoding error
                    print("Error decoding materials data: \(decodingError.localizedDescription)")
                    print("Data: \(String(data: data, encoding: .utf8) ?? "")")
                    print("Response: \(response)")
                }
            }
        }.resume()
    }
}

struct Material: Codable, Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    let description: String
    let category: String
    let quantity: Int
    let location: String
    let remark: String
    let type: String
    let remaining: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl = "image"
        case description
        case category
        case quantity
        case location
        case remark
        case type
        case remaining
    }
}

struct MaterialsListView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsListView()
    }
}

//
//  ItemView.swift
//  Assignment1
//
//  Created by Leo Cheung on 6/10/2023.
//

import SwiftUI

struct Items: Identifiable {
    let _id: String
    let title: String
    let image: String
    let quantity: Int
    let description: String
    let category: String
    let publisher: String
    let location: String
    let remark: String
    let type: String
    let borrower: String
}

struct ItemView: View {
    
    @State private var items: [Items] = []
    
    var body: some View {
        List(items) { typeItem in
            AsyncImage(url: URL(string: typeItem.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFit()
            Text(typeItem.id)
        }
        .onAppear(perform: startLoad)
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}


extension ItemView {
    
    func handleClientError(_ error: Error) {
        // Handle the client-side error here
        print("Client Error: \(error)")
        // Additional error handling logic can be implemented
        // For example, displaying an error message to the user
    }
    
    func handleServerError(_ response: URLResponse?) {
        // Handle the server-side error here
        if let httpResponse = response as? HTTPURLResponse {
            print("Server Error: Status Code \(httpResponse.statusCode)")
            // Additional error handling logic can be implemented
            // For example, checking the status code and displaying an appropriate error message to the user
        }
    }
    
    func startLoad() {
        
        let url = URL(string: "https://comp4107.azurewebsites.net/inventory?type=game")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                self.handleClientError(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response)
                return
            }
            
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data, let items = try? JSONDecoder().decode([Items].self, from: data) {
                   self.items = items
               }
        }
        
        task.resume()
    }
}

extension Items: Decodable {
}

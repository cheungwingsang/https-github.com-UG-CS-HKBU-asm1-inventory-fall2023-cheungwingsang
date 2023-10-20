//
//  ContentView.swift
//  Assignment1
//
//  Created by Leo Cheung on 6/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []

    var body: some View {
        TabView {
            ItemTypeView().tabItem {
                Image(systemName: "list.bullet.rectangle.fill")
                Text("Item Types")
            }
//            SearchBoxView(searchText: $searchText, searchResults: $searchResults).tabItem {
//                Image(systemName: "magnifyingglass.circle.fill")
//                Text("Search")
//            }
            SearchBarView().tabItem {
                Image(systemName: "magnifyingglass.circle.fill")
                Text("Search")
            }
            UserLoginView().tabItem {
                Image(systemName: "person.circle.fill")
                Text("User")
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
        }
    }
}




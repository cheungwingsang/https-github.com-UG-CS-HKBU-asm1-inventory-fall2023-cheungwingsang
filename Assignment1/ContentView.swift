//
//  ContentView.swift
//  Assignment1
//
//  Created by Leo Cheung on 6/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ItemTypeView().tabItem {
                Image(systemName: "multiply.circle.fill")
                Text("Item Types")
            }
            SearchView().tabItem {
                Image(systemName: "search.circle.fill")
                Text("Search")
            }
            UserLoginView().tabItem {
                Image(systemName: "login.circle.fill")
                Text("User Login")
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
        }
    }
}

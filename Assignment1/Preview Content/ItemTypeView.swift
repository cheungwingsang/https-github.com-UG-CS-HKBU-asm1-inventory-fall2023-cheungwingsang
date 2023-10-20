//
//  ItemTypeView.swift
//  Assignment1
//
//  Created by Leo Cheung on 6/10/2023.
//

import SwiftUI

struct ItemTypeView: View {
    var body: some View {
        NavigationView {
            ItemTypesListView()
                .navigationTitle("Item Types")
        }
    }
}

struct ItemTypesListView: View {
    var body: some View {
        List {
            NavigationLink(destination: GamesListView()) {
                Text("Games")
            }
            
            NavigationLink(destination: GiftsListView()) {
                Text("Gifts")
            }
            
            NavigationLink(destination: MaterialsListView()) {
                Text("Materials")
            }
            
            NavigationLink(destination: BooksListView()) {
                Text("Books")
            }
        }
    }
}

struct ItemTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ItemTypeView()
    }
}


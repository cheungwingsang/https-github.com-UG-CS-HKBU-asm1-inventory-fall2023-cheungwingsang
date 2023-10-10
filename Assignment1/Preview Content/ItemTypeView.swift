//
//  ItemTypeView.swift
//  Assignment1
//
//  Created by Leo Cheung on 6/10/2023.
//

import SwiftUI

struct ItemType: Identifiable {
    let id: String
    let title: String
}

struct ItemTypeView: View {
    var body: some View {
        NavigationView {
            List(ItemType.types) { itemType in
                NavigationLink(destination: ItemView()) {
                    HStack {
                        Text(itemType.title)
                    }
                }
            }
            .navigationTitle("Item Types")
        }
    }
}

#Preview {
    ItemTypeView()
}

extension ItemType {
    static let types: [ItemType] = [
        ItemType(id: "game", title: "Games"),
        ItemType(id: "gift", title: "Gifts"),
        ItemType(id: "material", title: "Materials"),
        ItemType(id: "book", title: "Books")
    ]
}

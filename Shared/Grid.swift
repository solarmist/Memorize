//
//  Grid.swift
//
//  Created by CS193p Instructor on 4/8/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

// This was modified to pass the index instead of the item for the view
// since a card object is a struct which is passed by value instead of
// reference.  So I needed to maintain references instead

import SwiftUI

struct Grid<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
    private var items: [Item]
    // swiftlint:disable:next identifier_name
    private var id: KeyPath<Item, ID>
    private var viewForIndex: (Int) -> ItemView

    init(_ items: [Item],
         // swiftlint:disable:next identifier_name
         id: KeyPath<Item, ID>,
         viewForIndex: @escaping (Int) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForIndex = viewForIndex
    }

    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: items.count,
                                 nearAspectRatio: 2.0/3.0,
                                 in: geometry.size))
        }
    }

    // Split these up so we don't have escaping closures like geometry escaping into this func
    private func body(for layout: GridLayout) -> some View {
        return ForEach(items.indices) { index in
            body(for: index, in: layout)
        }
    }

    private func body(for index: Int, in layout: GridLayout) -> some View {
        return Group {
            viewForIndex(index)
                .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                .position(layout.location(ofItemAt: index))
        }
    }
}

extension Grid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForIndex: @escaping (Int) -> ItemView) {
        self.init(items, id: \Item.id, viewForIndex: viewForIndex)
    }
}

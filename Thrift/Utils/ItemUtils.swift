//
//  ItemUtils.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import SwiftUI

struct ItemUtils {
    static let allIcons = ["tshirt.fill", "handbag.fill", "hat.cap.fill", "jacket.fill", "shoe.2.fill"]

    private static let iconReadableNames: [String: String.LocalizationValue] = [
        "tshirt.fill": "T-shirt",
        "handbag.fill": "Bag",
        "hat.cap.fill": "Hat",
        "jacket.fill": "Jacket",
        "shoe.2.fill": "Shoes"
    ]

    static func defaultName(for item: Item) -> String {
        let icon = randomIcon(for: item)
        if let key = iconReadableNames[icon] {
            return String(localized: key)
        }
        return ""
    }

    static func getCategories(from items: [Item]) -> [String] {
        var categories: [String] = []

        for item in items {
            if item.categories.isEmpty { continue }

            categories += item.categories.filter { categories.contains($0) == false && item.isPurchased == false }
        }

        return categories
    }

    static func randomIcon(for item: Item) -> String {
        if let stored = item.iconName {
            return stored
        }
        return allIcons[abs(item.id.intValue) % allIcons.count]
    }
}

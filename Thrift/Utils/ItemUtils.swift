//
//  ItemUtils.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import SwiftUI

struct ItemUtils {
    static func getCategories(from items: [Item]) -> [String] {
        var categories: [String] = []
        
        for item in items {
            if item.categories.isEmpty { continue }
            
            categories += item.categories.filter { categories.contains($0) == false && item.isPurchased == false }
        }
        
        return categories
    }
    
    static func randomIcon(for item: Item) -> String {
        return ["tshirt.fill", "handbag.fill", "hat.cap.fill", "jacket.fill", "shoe.2.fill"][abs(item.id.hashValue % 5)]
    }
}

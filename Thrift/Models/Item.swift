//
//  Item.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 07/10/25.
//

import SwiftUI
import SwiftData

@Model
class Item: Identifiable {
    var id: UUID = UUID()
    var iconName: String?

    @Attribute(.externalStorage)
    var imageData: Data

    var name: String
    var desc: String
    var price: Double
    var links: [String]
    var categories: [String]
    var isFavorite: Bool
    var isPurchased: Bool
    var wasCreated: Date
    
    @Transient
    private var cachedUIImage: UIImage?
    
    func getUIImage() -> UIImage? {
        if let cachedImage = cachedUIImage {
            return cachedImage
        }
        
        if let newImage = UIImage(data: imageData) {
            self.cachedUIImage = newImage
            return newImage
        }
        
        return nil
    }
    
    func updateImageData(_ data: Data) {
        self.imageData = data
        cachedUIImage = nil
    }
    
    init(imageData: Data = Data(), name: String = "", desc: String = "", price: Double = 0.0, links: [String] = [], categories: [String] = [], isFavorite: Bool = false, isPurchased: Bool = false) {
        self.imageData = imageData
        self.name = name
        self.desc = desc
        self.price = price
        self.links = links
        self.categories = categories
        self.isFavorite = isFavorite
        self.isPurchased = isPurchased
        self.wasCreated = Date()
        self.iconName = ItemUtils.allIcons.randomElement()
    }

    var transferable: ItemTransfer { ItemTransfer(id: id) }
}

extension Item {
    static let mock: Item = {
        let uiImage = UIImage(named: "jorts")
//        let data = uiImage?.pngData() ?? Data()
        let data = Data()
        
        return Item(imageData: data, name: "Jorts maneirasso", desc: "Imagina se eu compro essa parada e uso com aquela camiseta lá, nossa ia ficar muito foda...", price: 79.9999999, links: ["shopee.com", "aliexpress.com", "amazon.com"], categories: ["jorts", "bermuda legal", "vintageeeeeeee", "estilo", "maneiro"])
    }()
}

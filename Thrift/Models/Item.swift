//
//  Item.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 07/10/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@Model
class Item: Identifiable, Codable, Transferable {
    var id = UUID()
    
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
    }
    
    // Paradas pro drag and drop funcionar
    enum CodingKeys: String, CodingKey {
        case id, imageData, name, desc, price, links, categories, isFavorite, isPurchased, wasCreated
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .item)
    }
    
    // Métodos para conformar ao Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.imageData = try container.decode(Data.self, forKey: .imageData)
        self.name = try container.decode(String.self, forKey: .name)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.price = try container.decode(Double.self, forKey: .price)
        self.links = try container.decode([String].self, forKey: .links)
        self.categories = try container.decode([String].self, forKey: .categories)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.isPurchased = try container.decode(Bool.self, forKey: .isPurchased)
        self.wasCreated = try container.decode(Date.self, forKey: .wasCreated)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(name, forKey: .name)
        try container.encode(desc, forKey: .desc)
        try container.encode(price, forKey: .price)
        try container.encode(links, forKey: .links)
        try container.encode(categories, forKey: .categories)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isPurchased, forKey: .isPurchased)
        try container.encode(wasCreated, forKey: .wasCreated)
    }
}

extension Item {
    static let mock: Item = {
        let uiImage = UIImage(named: "jorts")
//        let data = uiImage?.pngData() ?? Data()
        let data = Data()
        
        return Item(imageData: data, name: "Jorts maneirasso", desc: "Imagina se eu compro essa parada e uso com aquela camiseta lá, nossa ia ficar muito foda...", price: 79.9999999, links: ["shopee.com", "aliexpress.com", "amazon.com"], categories: ["jorts", "bermuda legal", "vintageeeeeeee", "estilo", "maneiro"])
    }()
}

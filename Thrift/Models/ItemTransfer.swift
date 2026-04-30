//
//  ItemTransfer.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 30/04/26.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct ItemTransfer: Codable, Transferable, Sendable {
    let id: UUID

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .item)
    }
}

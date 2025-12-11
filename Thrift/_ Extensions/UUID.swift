//
//  UUID.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 13/10/25.
//

import Foundation

extension UUID {
    var intValue: Int {
        let bytes = self.uuid
        let value =
            UInt64(bytes.8) << 56 |
            UInt64(bytes.9) << 48 |
            UInt64(bytes.10) << 40 |
            UInt64(bytes.11) << 32 |
            UInt64(bytes.12) << 24 |
            UInt64(bytes.13) << 16 |
            UInt64(bytes.14) << 8  |
            UInt64(bytes.15)
        return Int(truncatingIfNeeded: value)
    }
}

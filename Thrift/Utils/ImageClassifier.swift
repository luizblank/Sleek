//
//  ImageClassifier.swift
//  Thrift
//
//  Created by Luiz Antonio Rosa Cardoso on 29/04/26.
//

import UIKit
import Vision

struct ImageClassifier {
    private static let confidenceThreshold: Float = 0.4

    static func suggestedName(from data: Data) async -> String? {
        guard let uiImage = UIImage(data: data),
              let ciImage = CIImage(image: uiImage) else { return nil }

        let oriented = ciImage.oriented(for: uiImage.imageOrientation)
        let request = VNClassifyImageRequest()
        let handler = VNImageRequestHandler(ciImage: oriented, options: [:])

        do {
            try handler.perform([request])
        } catch {
            return nil
        }

        guard let observations = request.results else { return nil }

        let candidate = observations
            .first { $0.confidence >= confidenceThreshold && !$0.identifier.isEmpty }

        guard let identifier = candidate?.identifier else { return nil }

        return prettify(identifier)
    }

    private static func prettify(_ identifier: String) -> String {
        let leaf = identifier.split(separator: ",").first.map(String.init) ?? identifier
        let cleaned = leaf
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .trimmingCharacters(in: .whitespaces)
        return cleaned.capitalized
    }
}

// CreateSticker.swift
// Thrift
// Comentado linha a linha por ChatGPT (Gepeto)

import SwiftUI // UIKit/SwiftUI não estritamente necessário aqui, mas o projeto usa UIImage.
import Vision // Framework que fornece modelos de visão (segmentação, detecção, etc.).
import CoreImage // Core Image: processamento de imagens.
import CoreImage.CIFilterBuiltins // API moderna para filtros Core Image.

struct StickerCreator {
    // Função pública que entra no fluxo: recebe os bytes da imagem e retorna bytes do PNG final.
    static func create(from data: Data) async throws -> Data {
        // Tenta criar um UIImage (usado pelo UIKit) e um CIImage (usado para processamento).
        guard let uiImage = UIImage(data: data), let ciImage = CIImage(image: uiImage) else {
            // Se falhar em criar qualquer representação, retorna erro de imagem inválida.
            throw StickerError.invalidImage
        }
        
        // Gira / aplica a orientação correta no CIImage, usando a orientação do UIImage.
        // Muitas fotos de celular vêm com "flag" de orientação no EXIF — essa linha normaliza isso.
        let orientedImage = ciImage.oriented(for: uiImage.imageOrientation)

        // Gera a máscara do sujeito (foreground) usando Vision. Aqui passamos a imagem já orientada.
        // A função abaixo retorna uma CIImage em escala de cinza onde branco = sujeito, preto = fundo.
        let maskImage = try await subjectMaskImage(from: orientedImage)
        
        // Aplica a máscara sobre a imagem orientada para gerar uma imagem com fundo transparente.
        let outputImage = apply(maskImage: maskImage, to: orientedImage)
        
        // Calcula o bounding box do sujeito a partir da máscara e recorta a imagem para esse retângulo.
        let croppedImage = cropToSubject(outputImage, mask: maskImage)
        
        // Renderiza o CIImage final em UIImage e converte para PNG. Se falhar, lança erro.
        guard let finalData = render(ciImage: croppedImage).pngData() else {
            throw StickerError.failedToRender
        }
        
        // Retorna os bytes do PNG final (imagem do sujeito com fundo transparente e já recortada).
        return finalData
    }
    
    // Erros possíveis do processo.
    enum StickerError: Error {
        case invalidImage
        case maskGenerationFailed
        case failedToRender
    }
    
    // MARK: - Geração da máscara com Vision
    private static func subjectMaskImage(from inputImage: CIImage) async throws -> CIImage {
        // Cria o request que instrui o Vision a gerar a máscara do primeiro plano.
        let request = VNGenerateForegroundInstanceMaskRequest()

        // O handler recebe a CIImage (já orientada) e prepara a execução do request.
        let handler = VNImageRequestHandler(
            ciImage: inputImage,
            options: [:]
        )
        
        // Executa o request (pode demorar um pouco; por isso estamos em async/try).
        try handler.perform([request])
        
        // Pega o primeiro resultado (se houver); se não houver, lança erro.
        guard let result = request.results?.first else {
            throw StickerError.maskGenerationFailed
        }
        
        // Gera um pixel buffer (CVPixelBuffer) escalado para as dimensões da imagem usada pelo handler.
        // Isso garante que a máscara tenha o mesmo tamanho que a imagem de entrada.
        let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)

        // Converte o pixel buffer em CIImage para uso no pipeline Core Image.
        return CIImage(cvPixelBuffer: maskPixelBuffer)
    }

    // MARK: - Aplicar máscara para remover fundo
    private static func apply(maskImage: CIImage, to inputImage: CIImage) -> CIImage {
        // Cria o filtro que combina imagem + máscara.
        let filter = CIFilter.blendWithMask()

        // Define a imagem de entrada (já orientada) para o filtro.
        filter.inputImage = inputImage

        // Define a máscara que indica onde mostrar a imagem (branco) e onde ficar transparente (preto).
        filter.maskImage = maskImage

        // Fundo vazio -> transparencia no lugar do fundo.
        filter.backgroundImage = CIImage.empty()

        // Retorna a saída do filtro. Aqui existe um force-unwrap (!) — em produção é melhor tratar com guard.
        return filter.outputImage!
    }

    // MARK: - Renderizar CIImage para UIImage
    private static func render(ciImage: CIImage) -> UIImage {
        // Cria um contexto temporário para rasterizar a CIImage em CGImage.
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            // Se falhar, retorna uma UIImage vazia. Em vez disso, você poderia lançar erro.
            return UIImage()
        }
        // Converte CGImage para UIImage e retorna.
        return UIImage(cgImage: cgImage)
    }
    
    // MARK: - Encontrar e cortar ao redor do sujeito (bounding box)
    private static func cropToSubject(_ image: CIImage, mask: CIImage) -> CIImage {
        // extent é o retângulo que descreve a área da máscara (x,y,width,height).
        let extent = mask.extent

        // Cria um contexto para rasterizar a máscara em CGImage para leitura de pixels.
        let context = CIContext(options: nil)
        
        // Rasteriza a máscara em um CGImage. Se não for possível, retorna a imagem original (fallback).
        guard let cgMask = context.createCGImage(mask, from: extent) else { return image }

        // Pega os bytes brutos do CGImage para ler pixel a pixel.
        guard let data = cgMask.dataProvider?.data else { return image }
        let ptr = CFDataGetBytePtr(data)
        
        // Alguns metadados do CGImage: quantos bytes tem cada linha, e as dimensões.
        let bytesPerRow = cgMask.bytesPerRow
        let height = Int(extent.height)
        let width = Int(extent.width)
        
        // Inicializa as variáveis que vão guardar a caixa mínima e máxima
        var minX = width, maxX = 0, minY = height, maxY = 0
        
        // Percorre cada pixel da máscara para ver onde existem pixels "visíveis".
        for y in 0..<height {
            for x in 0..<width {
                // Calcula o offset no bloco de bytes. Aqui assumimos 4 bytes por pixel.
                let offset = y * bytesPerRow + x * 4

                // Lê o primeiro byte. No seu fluxo, a máscara resultante está legível aqui.
                // Esse byte representa a intensidade (quanto branco/visível tem no pixel).
                let alpha = ptr![offset] // valor 0..255

                // Se o valor for maior que 10 (pequeno threshold), consideramos que o pixel faz parte do sujeito.
                if alpha > 10 {
                    // Atualiza a bounding box: guarda min/max de X e Y que possuem pixels.
                    minX = min(minX, x)
                    maxX = max(maxX, x)
                    minY = min(minY, y)
                    maxY = max(maxY, y)
                }
            }
        }
        
        // Se não encontrou nenhum pixel "visível", não corta nada (retorna a imagem original).
        guard minX < maxX, minY < maxY else { return image }
        
        // Importante: os pixels lidos do CGImage têm origem no canto superior esquerdo,
        // enquanto o Core Image tem origem no canto inferior esquerdo. Por isso fazemos (height - maxY)
        // para ajustar a coordenada Y e obter o retângulo correto no sistema do Core Image.
        let cropRect = CGRect(
            x: extent.origin.x + CGFloat(minX),
            y: extent.origin.y + CGFloat(height - maxY),
            width: CGFloat(maxX - minX),
            height: CGFloat(maxY - minY)
        )
        
        // Corta a imagem processada para o retângulo encontrado e retorna.
        return image.cropped(to: cropRect)
    }
}

// MARK: - Conversão de orientações
extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        // Mapeia cada caso de UIImage.Orientation para CGImagePropertyOrientation equivalente.
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}

// MARK: - Atalho para aplicar orientação em CIImage
extension CIImage {
    func oriented(for orientation: UIImage.Orientation) -> CIImage {
        // Simples atalho que transforma a orientação UIKit para a orientação Core Image.
        return self.oriented(CGImagePropertyOrientation(orientation))
    }
}

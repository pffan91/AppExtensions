//
//  UIImageExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit

extension UIImage {

    static let empty: UIImage = .empty()

    static func empty(size: CGFloat, color: UIColor = .clear) -> UIImage {
        empty(size: CGSize(width: size, height: size), color: color)
    }

    static func empty(size: CGSize = .init(width: 1, height: 1), color: UIColor = .clear, scale: CGFloat = 1) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        guard let cgImage = image.cgImage else { return image }
        return UIImage(cgImage: cgImage)
    }

    func scaled(by scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIGraphicsImageRenderer(size: newSize).image(actions: { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }).withRenderingMode(renderingMode)
    }

    func resizedImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / size.width
        let newSize = CGSize(width: newWidth, height: size.height * scale)
        return UIGraphicsImageRenderer(size: newSize).image(actions: { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }).withRenderingMode(renderingMode)
    }

    func with(alpha: CGFloat = 1.0) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        return UIGraphicsImageRenderer(size: self.size, format: format).image { context in
            draw(in: context.format.bounds, blendMode: .normal, alpha: alpha)
        }.withRenderingMode(renderingMode)
    }

    func tintImage(color: UIColor) -> UIImage {
        let tintedImage = UIGraphicsImageRenderer(size: size).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
        return tintedImage.withRenderingMode(.alwaysOriginal)
    }

    static func loadImage(from url: URL) async throws -> UIImage? {
        guard let (data, _) = try? await URLSession.shared.data(for: URLRequest(url: url)) else { return nil }
        return UIImage(data: data)
    }
}

extension UIImage.Configuration {
    /// Symbol image configuration with small scale
    static let smallSymbol = UIImage.SymbolConfiguration(scale: .small)
    /// Symbol image configuration with medium scale
    static let mediumSymbol = UIImage.SymbolConfiguration(scale: .medium)
    /// Symbol image configuration with large scale
    static let largeSymbol = UIImage.SymbolConfiguration(scale: .large)
    /// Symbol image configuration with light weight
    static let lightSymbol = UIImage.SymbolConfiguration(weight: .light)
    /// Symbol image configuration with small scale and light weight
    static let smallLightSymbol = UIImage.SymbolConfiguration.smallSymbol.applying(.lightSymbol)
    /// Symbol image configuration with medium scale and light weight
    static let mediumLightSymbol = UIImage.SymbolConfiguration.mediumSymbol.applying(.lightSymbol)
    /// Symbol image configuration with large scale and light weight
    static let largeLightSymbol = UIImage.SymbolConfiguration.largeSymbol.applying(.lightSymbol)

    static let defaultSymbol = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17))
}

extension UIImageView {

    func roundCornersForAspectFit(radius: CGFloat) {
        guard let image = self.image else { return }

        // Calculate drawingRect
        let boundsScale = self.bounds.size.width / self.bounds.size.height
        let imageScale = image.size.width / image.size.height

        var drawingRect: CGRect = self.bounds

        if boundsScale > imageScale {
            drawingRect.size.width = drawingRect.size.height * imageScale
            drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
        } else {
            drawingRect.size.height = drawingRect.size.width / imageScale
            drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
        }
        let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

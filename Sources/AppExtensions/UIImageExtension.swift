//
//  UIImageExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit

public extension UIImage {

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

    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size

        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)

        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: scaledSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage ?? self
    }

    func toBase64() -> String? {
        pngData()?.base64EncodedString()
    }

    // MARK: - GIF Loading

    class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source: source)
    }

    class func gifImageWithURL(gifUrl: String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }

        return gifImageWithData(data: imageData)
    }

    class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifImageWithData(data: imageData)
    }

    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)

        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        guard var delay = delayObject as? Double else { return 0 }

        if delay < 0.1 {
            delay = 0.1
        }

        return delay
    }

    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        if a! < b! {
            let c = a!
            a = b!
            b = c
        }

        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b!
            } else {
                a = b!
                b = rest
            }
        }
    }

    class func gcdForArray(array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }

        return gcd
    }

    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        return UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
    }
}

public extension UIImage.Configuration {
    /// Symbol image configuration with small scale
    public static let smallSymbol = UIImage.SymbolConfiguration(scale: .small)
    /// Symbol image configuration with medium scale
    public static let mediumSymbol = UIImage.SymbolConfiguration(scale: .medium)
    /// Symbol image configuration with large scale
    public static let largeSymbol = UIImage.SymbolConfiguration(scale: .large)
    /// Symbol image configuration with light weight
    public static let lightSymbol = UIImage.SymbolConfiguration(weight: .light)
    /// Symbol image configuration with small scale and light weight
    public static let smallLightSymbol = UIImage.SymbolConfiguration.smallSymbol.applying(.lightSymbol)
    /// Symbol image configuration with medium scale and light weight
    public static let mediumLightSymbol = UIImage.SymbolConfiguration.mediumSymbol.applying(.lightSymbol)
    /// Symbol image configuration with large scale and light weight
    public static let largeLightSymbol = UIImage.SymbolConfiguration.largeSymbol.applying(.lightSymbol)

    public static let defaultSymbol = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17))
}

public extension UIImageView {

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

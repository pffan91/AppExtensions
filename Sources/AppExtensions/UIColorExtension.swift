//
//  UIColorExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 12/01/2025.
//

import UIKit

public extension UIColor {

    /// Creates a UIColor from a hex string, with an option to use sRGB or Display P3.
    ///
    /// - Parameters:
    ///   - hex: A string representing the hex color (6 or 8 digits, optional "#").
    ///   - useDisplayP3: Pass `true` to interpret the color in the Display P3 color space (requires iOS 10+).
    ///                   Pass `false` (default) to interpret in sRGB — which usually matches Figma.
    ///
    /// - Returns: A `UIColor` if the hex was valid, otherwise `nil`.
    public convenience init?(hex: String, useDisplayP3: Bool = true) {
        // 1) Trim and remove "#" if present
        var sanitizedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if sanitizedHex.hasPrefix("#") {
            sanitizedHex.removeFirst()
        }

        // 2) Must be 6 (RGB) or 8 (RGBA) characters
        guard sanitizedHex.count == 6 || sanitizedHex.count == 8 else {
            return nil
        }

        // 3) Convert string to an integer
        var rgbValue: UInt64 = 0
        guard Scanner(string: sanitizedHex).scanHexInt64(&rgbValue) else {
            return nil
        }

        // 4) Extract components
        let red, green, blue, alpha: CGFloat

        if sanitizedHex.count == 6 {
            // #RRGGBB
            red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >>  8) / 255.0
            blue  = CGFloat((rgbValue & 0x0000FF)      ) / 255.0
            alpha = 1.0
        } else {
            // #RRGGBBAA
            red   = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((rgbValue & 0x0000FF00) >>  8) / 255.0
            alpha = CGFloat((rgbValue & 0x000000FF)      ) / 255.0
        }

        // 5) Initialize color in the chosen color space
        if useDisplayP3, #available(iOS 10.0, *) {
            // Display P3
            self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        } else {
            // sRGB (commonly matches Figma)
            // Note: iOS’s default init(red:green:blue:alpha:) uses sRGB-like color space,
            // but we can be explicit if needed with srgbRed initializer (iOS 13+).
            // For broad compatibility, we'll use the "default" initializer below.
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

public extension UIColor {

    // MARK: - Additional Initializers

    /// Initialize from RGB components (0-255)
    public convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }

    /// Initialize from integer RGB value (e.g., 0xFF0000 for red)
    public convenience init(_ rgb: Int, a: CGFloat = 1) {
        self.init(r: (rgb >> 16) & 0xFF, g: (rgb >> 8) & 0xFF, b: rgb & 0xFF, a: a)
    }

    class func rgb(from hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((hex & 0x00FF00) >> 8) / 0xFF
        let blue = CGFloat(hex & 0x0000FF) / 0xFF
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: - Hex String Conversion

    /// Convert to hex string (e.g., "#FF0000")
    public var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return [r, g, b].map { String(format: "%02lX", Int($0 * 255)) }.reduce("#", +)
    }

    // MARK: - Alpha Modifier

    /// Shortcut for alpha modifier
    public func alpha(_ value: CGFloat) -> UIColor {
        withAlphaComponent(value)
    }

    // MARK: - Image Generation

    /// Generate a UIImage filled with this color
    public func image(with size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: CGPoint(), size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        self.setFill()
        UIRectFill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

//
//  UIColorExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 12/01/2025.
//

import UIKit

extension UIColor {

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

extension UIColor {
    class func rgb(from hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((hex & 0x00FF00) >> 8) / 0xFF
        let blue = CGFloat(hex & 0x0000FF) / 0xFF
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

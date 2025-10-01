//
//  StringExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit
import CryptoKit
import Foundation

public extension String {

    func toBool() -> Bool {
        switch self.lowercased() {
        case "true", "yes", "1", "on": true
        case "false", "no", "0", "off": false
        default: false
        }
    }

    /// Replaces all non-alphanumeric characters (except '-' and '_') with '-'.
    var sanitizedForPayload: String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
        return self.map { char in
            if let scalar = char.unicodeScalars.first, allowed.contains(scalar) {
                return char
            } else {
                return "-"
            }
        }.reduce("") { $0 + String($1) }
    }

    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "`#%^{}\"[]|\\<> ").inverted)
    }

    /// Extension property
    var localized: String {
        NSLocalizedString(self, value: "!\(self)?", comment: "")
    }

    /// Extension method
    func localizedFormat(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }

    /// Capitalize first letter of the first word only
    var capitalizedFirstLetter: String {
        guard !isEmpty else { return self }
        return prefix(1).capitalized + dropFirst()
    }

    /// Uncapitalize first letter of the first word only
    var uncapitalizedFirstLetter: String {
        guard !isEmpty else { return self }
        return prefix(1).lowercased() + dropFirst()
    }

    /// Extension method
    mutating func replaceFirstOccurrence(_ original: String, with newString: String) {
        if let range = self.range(of: original) {
            replaceSubrange(range, with: newString)
        }
    }

    /// Extension property
    var trimmed: String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// Extension property
    var withEscapedNewlines: String {
        replacingOccurrences(of: "\n", with: "\\n")
    }

    /// Returns string with "…" if string contains multiline text.
    var truncatedTail: String {
        let lines = components(separatedBy: "\n")
        return lines.count > 1 ? "\(lines[0])\("…")" : self
    }

    // MARK: - Convertations

    /// Extension method
    func fromUnicodeCharHexCode() -> String? {
        guard
            let charCode = UInt32(self, radix: 16),
            let unicodeScalar = UnicodeScalar(charCode)
        else { return nil }
        return String(unicodeScalar)
    }

    /// Extension method
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Extension method
    func toBase64() -> String {
        Data(utf8).base64EncodedString()
    }

    /// Extension method
    func sha256() -> String {
        let data = Data(self.utf8)
        let hashDigest = SHA256.hash(data: data)
        let hashString = hashDigest.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }

    /// Extension method.
    /// Use NSAttributedString with NSHTMLTextDocumentType from main thread only!
    func unescapeHTML() -> String {
        guard let data = data(using: .utf8) else { return self }
        let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
        return attributedString?.string ?? self
    }

    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }

    // MARK: -

    /// Generates *CGSize* for string within provided width to fit in. Uses System Font.
    /// - Parameter width: Width to fit in.
    /// - Parameter systemFontSize: Size of system font.
    func sizeOfString(constrainedToWidth width: Double, systemFontSize: CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: systemFontSize)]
        let attString = NSAttributedString(string: self, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
    }

    /// Generates *CGSize* for string within provided width to fit in. Uses custom font.
    /// - Parameter width: Width to fit in.
    /// - Parameter font: Custom font.
    func sizeOfString(constrainedToWidth width: Double, font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let attString = NSAttributedString(string: self, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
    }

    /// Compares origin string and another string and returns range of the same substring.
    /// - Parameter anotherString: String with which need to compare origin string.
    /// - returns: Range where: `start` - start of the origin string, `end` - the first index of uncompared character.
    func compare(with anotherString: String) -> Range<Index>? {
        let anotherStringCharacters = Array(anotherString)
        for (index, origChar) in self.enumerated() {
            let anotherChar = anotherStringCharacters[index]
            if origChar != anotherChar {
                return startIndex..<Index(utf16Offset: index, in: self)
            }
        }
        return nil
    }

    // MARK: - Static Functions

    /// Extension method
    static func generatePassword(length: Int = 12) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*?:;_-+=()<>{}"
        var randomString: String = ""
        for _ in 0..<length {
            randomString += base[Int.random(in: 0..<base.count)]
        }
        return randomString
    }

    // MARK: - String Subscript

    subscript (i: Int) -> String {
        self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

// MARK: - Optionals to String interpolation
// Usage: print("The value is \(nonStringOptionalValue ??? "unknown")")

/// Custom Optionals to String interpolation
infix operator ???: NilCoalescingPrecedence

public func ???<T> (optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}

public extension NSAttributedString {
    static func partiallyBoldText(_ regular: String, bold: String, regularFont: UIFont, boldFont: UIFont, foregroundColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: regular, attributes: [.font: regularFont, .foregroundColor: foregroundColor])
        let boldAttributedString = NSMutableAttributedString(string: bold, attributes: [.font: boldFont, .foregroundColor: foregroundColor])
        attributedString.append(boldAttributedString)
        return attributedString
    }
}

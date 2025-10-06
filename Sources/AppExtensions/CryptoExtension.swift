//
//  CryptoExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 06/10/2025.
//

import Foundation
import CommonCrypto

public func MD5(_ str: String) -> String {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)

    if let d = str.data(using: .utf8) {
        _ = d.withUnsafeBytes { body -> String in
            CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
            return ""
        }
    }

    return (0 ..< length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
    }
}

public func SHA256(_ str: String) -> String {
    let length = Int(CC_SHA256_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)

    if let d = str.data(using: .utf8) {
        _ = d.withUnsafeBytes { body -> String in
            CC_SHA256(body.baseAddress, CC_LONG(d.count), &digest)
            return ""
        }
    }

    return (0 ..< length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
    }
}

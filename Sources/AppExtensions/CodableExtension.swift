//
//  CodableExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 06/10/2025.
//

import Foundation

public struct DecodableError: LocalizedError {
    public var errorDescription: String? {
        return ""
    }
}

public extension Decodable {
    public static func from(json: String) throws -> Self {
        let data = json.data(using: .utf8, allowLossyConversion: false) ?? Data()
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }

    public init(JSONString: String) throws {
        self = try Self.from(json: JSONString)
    }
}

public extension Encodable {
    func json() throws -> String {
        let data = try JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8) ?? ""
    }
}

public extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

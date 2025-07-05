//
//  URLRequestExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 18/01/2025.
//

import Foundation

public extension URLRequest {
    /// Returns a best-effort cURL representation of this URLRequest.
    func asCurlCommand() -> String {
        guard let url = self.url else { return "curl command could not be created" }

        var components: [String] = ["curl"]

        // Method
        if httpMethod?.uppercased() == "POST" {
            components.append("-X POST")
        } else if let method = httpMethod, method.uppercased() != "GET" {
            // Add other methods if needed
            components.append("-X \(method.uppercased())")
        }

        // URL
        components.append("\"\(url.absoluteString)\"")

        // Headers
        if let allHeaders = allHTTPHeaderFields {
            for (header, value) in allHeaders {
                components.append("-H \"\(header): \(value)\"")
            }
        }

        // Body (attempt to convert to string)
        if let httpBody = httpBody, !httpBody.isEmpty {
            // For JSON or text-based bodies, try converting to UTF-8 string
            if let bodyString = String(data: httpBody, encoding: .utf8) {
                // Escape any quotes in the body
                let escapedBody = bodyString
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "`", with: "\\`")

                components.append("-d \"\(escapedBody)\"")
            } else {
                // If not convertible to string, present as base64 or some placeholder
                components.append("# Body data not UTF-8 encodable, length \(httpBody.count)")
            }
        }

        return components.joined(separator: " \\\n\t")
    }
}

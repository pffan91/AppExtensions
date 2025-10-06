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

public extension URLRequest {

    /// Returns a cURL command for a request
    /// - return A String object that contains cURL command or "" if an URL is not properly initalized.
    var cURL: String {
        guard
            let url = url,
            let httpMethod = httpMethod,
            !url.absoluteString.utf8.isEmpty
        else {
            return ""
        }

        var curlCommand = "curl --verbose \\\n"

        // URL
        curlCommand = curlCommand.appendingFormat(" '%@' \\\n", url.absoluteString)

        // Method if different from GET
        if "GET" != httpMethod {
            curlCommand = curlCommand.appendingFormat(" -X %@ \\\n", httpMethod)
        }

        // Headers
        let allHeadersFields = allHTTPHeaderFields!
        let allHeadersKeys = Array(allHeadersFields.keys)
        let sortedHeadersKeys = allHeadersKeys.sorted(by: <)
        for key in sortedHeadersKeys {
            curlCommand = curlCommand.appendingFormat(" -H '%@: %@' \\\n", key, self.value(forHTTPHeaderField: key)!)
        }

        // HTTP body
        if let httpBody = httpBody, !httpBody.isEmpty {
            let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8)!
            let escapedHttpBody = URLRequest.escapeAllSingleQuotes(httpBodyString)
            curlCommand = curlCommand.appendingFormat(" --data '%@' \\\n", escapedHttpBody)
        }

        return curlCommand
    }

    /// Escapes all single quotes for shell from a given string.
    static func escapeAllSingleQuotes(_ value: String) -> String {
        return value.replacingOccurrences(of: "'", with: "'\\''")
    }

    static func fileExistsAt(url: URL, completion: @escaping (Bool) -> Void) {
        let checkSession = Foundation.URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 1.0 // Adjust to your needs

        let task = checkSession.dataTask(with: request as URLRequest) { _, response, _ in
            if let httpResp = response as? HTTPURLResponse {
                completion(httpResp.statusCode == 200)
            }
        }

        task.resume()
    }
}


//
//  File.swift
//  
//
//  Created by Shyngys Kuandyk on 10.08.2023.
//

import Foundation
import WebKit
import Combine

public extension WKWebView {
    func clearCookieAndStorage(completition: @escaping () -> Void) {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                print("*** cookie " + record.displayName)
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }

            completition()
        }
    }
}

public extension WKWebView {
    func evaluateJavaScriptPublisher(_ javaScriptString: String,_ customError: Error? = nil) -> AnyPublisher<Any?, Error> {
        return Future<Any?, Error> { [weak self] promise in
            self?.evaluateJavaScript(javaScriptString) { (result, error) in
                if let error = error {
                    promise(.failure(customError ?? error))
                } else {
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

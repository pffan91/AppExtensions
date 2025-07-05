//
//  NotificationExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import Foundation

public extension Notification.Name {

    func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
        }
    }

    func post(_ id: UUID) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: self, object: nil, userInfo: [Notification.uuidKey: id])
        }
    }

    func post(_ error: Error) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: self, object: nil, userInfo: [Notification.errorKey: error])
        }
    }
}

public extension Notification {

    public static let uuidKey = "UUID"
    public static let errorKey = "Error"

    func contains(_ id: UUID) -> Bool {
        (userInfo?[Notification.uuidKey] as? UUID) == id
    }
}

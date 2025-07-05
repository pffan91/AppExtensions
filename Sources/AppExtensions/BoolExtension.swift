//
//  BoolExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 18/01/2025.
//

import Foundation

public extension Bool {
    func toString() -> String {
        return self ? "on" : "off"
    }
}

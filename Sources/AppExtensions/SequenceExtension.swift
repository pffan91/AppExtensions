//
//  SequenceExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 24/05/2025.
//

import Foundation

public extension Sequence {

    /// Extension method
    func first<T>(_ neededType: T.Type) -> T? {
        return first(where: { $0 is T }) as? T
    }
}

public extension Sequence where Iterator.Element: Hashable {

    /// Extension method
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

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

    // MARK: - KeyPath-based Transformations

    @inlinable public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { $0[keyPath: keyPath] }
    }

    @inlinable public func flatMap<T>(_ keyPath: KeyPath<Element, T>) -> [T.Element] where T: Sequence {
        flatMap { $0[keyPath: keyPath] }
    }

    @inlinable public func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        compactMap { $0[keyPath: keyPath] }
    }

    // MARK: - KeyPath-based Sorting

    @inlinable public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    // MARK: - KeyPath-based Grouping

    @inlinable public func grouped<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [T: [Element]] {
        .init(grouping: self) { $0[keyPath: keyPath] }
    }

    // MARK: - KeyPath-based Aggregation

    @inlinable public func sum<T>(_ keyPath: KeyPath<Element, T>) -> T where T: Numeric {
        reduce(0) { $0 + $1[keyPath: keyPath] }
    }

    @inlinable public func sum<T>(_ keyPath: KeyPath<Element, T?>) -> T where T: Numeric {
        reduce(0) { $0 + ($1[keyPath: keyPath] ?? 0) }
    }
}

public extension Sequence where Iterator.Element: Hashable {

    /// Extension method
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

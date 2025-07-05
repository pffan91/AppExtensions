//
//  CombineExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import Combine

typealias Cancellables = Set<AnyCancellable>

extension Publisher where Failure == Never {

    /// Assigns each element from a Publisher to a property on an object, but avoids retian cycle if object holds cancellable for this Subscriber.
    ///
    /// - Parameters:
    ///        - keyPath: The key path of the property to assign.
    ///        - object: The object on which to assign the value (weak reference).
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, onWeak object: Root) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

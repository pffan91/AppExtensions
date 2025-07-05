//
//  ArrayExtension.swift
//  TopDrive
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import Foundation
import UIKit

extension Array {

    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    @discardableResult
    mutating func moveElement(at: Index, to: Index) -> Bool {
        guard indices.contains(at) && indices.contains(to) else { return false }
        insert(remove(at: at), at: to)
        return true
    }
}

extension Array where Element: Identifiable {

    subscript(id: Element.ID) -> Element? {
        get { first { $0.id == id } }
        set {
            guard let element = newValue else {
                return removeAll { $0.id == id }
            }
            if let index = self.firstIndex(where: { $0.id == id }) {
                self[index] = element
            } else {
                append(element)
            }
        }
    }

    /// Check by id if array contains identifiable element
    func contains(_ id: Element.ID) -> Bool {
        contains { $0.id == id }
    }

    /// Get first index of identifiable element specified by id
    func index(of id: Element.ID) -> Int? {
        firstIndex { $0.id == id }
    }
}

extension Array {
    func sortedArrayByPosition() -> [Element] {
        return sorted(by: { (obj1 : Element, obj2 : Element) -> Bool in

            let view1 = obj1 as! UIView
            let view2 = obj2 as! UIView

            let x1 = view1.frame.minX
            let y1 = view1.frame.minY
            let x2 = view2.frame.minX
            let y2 = view2.frame.minY

            if y1 != y2 {
                return y1 < y2
            } else {
                return x1 < x2
            }
        })
    }
}

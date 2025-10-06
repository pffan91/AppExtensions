//
//  CGGeometryExtension.swift
//  Avtobot
//
//  CGPoint, CGSize, CGRect, UIEdgeInsets, CGAffineTransform extensions and operators
//

import UIKit

// MARK: - CGPoint Operators

public func + (l: CGPoint, r: CGPoint) -> CGPoint {
    CGPoint(x: l.x + r.x, y: l.y + r.y)
}

public func - (l: CGPoint, r: CGPoint) -> CGPoint {
    CGPoint(x: l.x - r.x, y: l.y - r.y)
}

public func * (l: CGPoint, r: CGFloat) -> CGPoint {
    CGPoint(x: l.x * r, y: l.y * r)
}

public func / (l: CGPoint, r: CGFloat) -> CGPoint {
    CGPoint(x: l.x / r, y: l.y / r)
}

// MARK: - CGSize Operators

public func + (l: CGSize, r: CGFloat) -> CGSize {
    CGSize(width: l.width + r, height: l.height + r)
}

public func - (l: CGSize, r: CGFloat) -> CGSize {
    CGSize(width: l.width - r, height: l.height - r)
}

public func * (l: CGSize, r: CGFloat) -> CGSize {
    CGSize(width: l.width * r, height: l.height * r)
}

public func / (l: CGSize, r: CGFloat) -> CGSize {
    CGSize(width: l.width / r, height: l.height / r)
}

public func + (l: CGSize, r: CGSize) -> CGSize {
    CGSize(width: l.width + r.width, height: l.height + r.height)
}

public func - (l: CGSize, r: CGSize) -> CGSize {
    CGSize(width: l.width - r.width, height: l.height - r.height)
}

public func + (l: CGSize, r: UIEdgeInsets) -> CGSize {
    CGSize(width: l.width + r.left + r.right, height: l.height + r.top + r.bottom)
}

// MARK: - CGRect Extensions

extension CGRect {

    public func inset(by d: CGFloat) -> CGRect {
        insetBy(dx: d, dy: d)
    }
}

// MARK: - CGRect Operators

public func * (l: CGRect, r: CGFloat) -> CGRect {
    CGRect(x: l.origin.x * r, y: l.origin.y * r, width: l.width * r, height: l.height * r)
}

public func / (l: CGRect, r: CGFloat) -> CGRect {
    CGRect(x: l.origin.x / r, y: l.origin.y / r, width: l.width / r, height: l.height / r)
}

public func + (l: CGRect, r: CGPoint) -> CGRect {
    CGRect(x: l.origin.x + r.x, y: l.origin.y + r.y, width: l.width, height: l.height)
}

// MARK: - UIEdgeInsets Extensions

extension UIEdgeInsets {

    public static func top(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }

    public static func left(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }

    public static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }

    public static func right(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }

    public static func vertical(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }

    public static func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }
}

// MARK: - UIEdgeInsets Operators

public func + (l: UIEdgeInsets, r: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: l.top + r.top, left: l.left + r.left, bottom: l.bottom + r.bottom, right: l.right + r.right)
}

// MARK: - CGAffineTransform Extensions

extension CGAffineTransform {

    public init(from: CGRect, to: CGRect) {
        self = CGAffineTransform(translationX: to.midX - from.midX, y: to.midY - from.midY)
            .scaledBy(x: to.width / from.width, y: to.height / from.height)
    }
}

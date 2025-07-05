//
//  CGExtensions.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 22/11/2024.
//

import UIKit

extension CGFloat {
    static var onePixel: CGFloat {
        return 1 / UIScreen.main.nativeScale
    }

    func scale(by textStyle: UIFont.TextStyle) -> CGFloat { UIFontMetrics(forTextStyle: textStyle).scaledValue(for: self) }
}

extension Double {
    func scale(by textStyle: UIFont.TextStyle) -> CGFloat { UIFontMetrics(forTextStyle: textStyle).scaledValue(for: CGFloat(self)) }
}

extension Int {
    func scale(by textStyle: UIFont.TextStyle) -> CGFloat { UIFontMetrics(forTextStyle: textStyle).scaledValue(for: CGFloat(self)) }
}

extension CGRect {

    var center: CGPoint {
        get { return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2) }
        set { origin = CGPoint(x: newValue.x - width / 2, y: newValue.y - height / 2) }
    }

    init(center: CGPoint, size: CGSize) {
        self.init(origin: .zero, size: size)
        self.center = center
    }
}

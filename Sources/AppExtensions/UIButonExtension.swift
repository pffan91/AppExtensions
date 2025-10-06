//
//  UIButonExtension.swift
//  Avtobot
//
//  Created by Vladyslav Semenchenko on 09/05/2023.
//  Copyright © 2023 Alexei. All rights reserved.
//

import UIKit

// TODO: Wrong solution, need to refactor !!!
public extension UIButton {
    fileprivate struct AssociatedKey {
        static var pdfURL = "pdfURL"
    }

    var pdfURL: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.pdfURL) as? URL
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.pdfURL, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIButton {
    func addSpacingBetweenTitleAndEdges(spacing: CGFloat) {
        contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
}

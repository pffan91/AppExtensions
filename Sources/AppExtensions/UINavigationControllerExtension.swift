//
//  UINavigationControllerExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit

public extension UINavigationController {
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) {
        guard !viewControllers.isEmpty else { completion(); return }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}

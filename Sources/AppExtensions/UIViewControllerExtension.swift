//
//  UIViewControllerExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit
import SwiftUI

extension UIViewController {

    static var current: UIViewController? {
        UIApplication.shared.currentWindow?.rootViewController?.current
    }

    var current: UIViewController {
        var vcCurrent = self
        while let vcPresented = vcCurrent.presentedViewController {
            vcCurrent = vcPresented
        }
        return vcCurrent
    }

    var topmostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topmostViewController
        }
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topmostViewController ?? nav
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topmostViewController ?? tab
        }
        return self
    }

    /// Extension method
    @objc func dismissWithAnimation(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }

    /// Extension method
    func addChild(viewController child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// Extension method
    func removeFromParentViewController() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    /// Back button with empty title (arrow only) for child view controllers pushed from this view conroller
    func clearBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    /// Hides keyboard on tap.
    func hideKeyboardOnTapInside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        navigationController?.view.endEditing(true)
    }

    func changeRootViewController(with viewController: UIViewController, 
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.3,
                                  completion: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.currentWindow else { return }
        if animated {
            UIView.transition(with: window, duration: duration, options: .transitionCrossDissolve, animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = viewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: completion)
        } else {
            window.rootViewController = viewController
            completion?(true)
        }
    }
}

extension UIViewController {
    /// heightPadding is a magic constant. Tweak it for pixel perfect height of views. Why it needed? Looks like UIKit can not correctly check and apply padding of root's view. If root view will be withut padding - everything is ok. Need to find another solution or fix.
    static func calculateHeight<Content: View>(for view: Content, width: CGFloat, heightPadding: CGFloat = 12) -> CGFloat {
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        let sizingView = UIView()
        sizingView.addSubview(hostingController.view)
        hostingController.view.constrainToSides(ignoringSafeArea: true)
        hostingController.view.widthAnchor.constraint(equalToConstant: width).isActive = true
        sizingView.setNeedsLayout()
        sizingView.layoutIfNeeded()

        return  hostingController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + heightPadding
    }

    static func calculateHeight(for viewController: UIViewController, width: CGFloat, heightPadding: CGFloat = 12) -> CGFloat {
        let hostingController = viewController
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        let sizingView = UIView()
        sizingView.addSubview(hostingController.view)
        hostingController.view.constrainToSides(ignoringSafeArea: true)
        hostingController.view.widthAnchor.constraint(equalToConstant: width).isActive = true
        sizingView.setNeedsLayout()
        sizingView.layoutIfNeeded()

        return  hostingController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + heightPadding
    }
}

//
//  UIApplicationExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit

public extension UIApplication {

    var currentWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter({ $0.isKeyWindow }).first
    }

    var activeWindow: UIWindow? {
        windows.first { $0.isKeyWindow } ?? windows.first
    }

    class func topViewController(controller: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
              // First will be smallest for the device class, last will be the largest for device class
              let lastIcon = iconFiles.lastObject as? String,
              let icon = UIImage(named: lastIcon) else {
            return nil
        }

        return icon
    }
}

//
//  UIAlertControllerExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit

public extension UIAlertController {

    static func message(_ message: String, title: String = "", closeTitle: String, showCopyAction: Bool = false, copyTitle: String, parent: UIViewController? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if showCopyAction {
            alert.addAction(UIAlertAction(title: copyTitle, style: .default) { _ in
                UIPasteboard.general.string = message
                completion?()
            })
        }
        let closeAction = UIAlertAction(title: closeTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(closeAction)
        if showCopyAction {
            alert.preferredAction = closeAction
        }
        DispatchQueue.main.async {
            (parent ?? UIViewController.current!).present(alert, animated: true)
        }
    }

    static func confirm(_ message: String, title: String = "", parent: UIViewController? = nil, cancelTitle: String, cancelAction: (() -> Void)? = nil, confirmTitle: String, preferredStyle: UIAlertController.Style = .alert, confirmStyle: UIAlertAction.Style = .default, confirmAction: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        })
        let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            confirmAction()
        }
        alert.addAction(confirmAction)
        alert.preferredAction = confirmAction
        DispatchQueue.main.async {
            guard let currentViewController = parent ?? UIViewController.current else {
                return assertionFailure("Current controller was not found!")
            }
            currentViewController.present(alert, animated: true)
        }
    }

    static func textfield(_ parent: UIViewController? = nil, title: String = "", message: String? = nil, placeholder: String, initialText: String? = nil, doneTitle: String, cancelTitle: String, doneHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.font = .systemFont(ofSize: 17)
            textField.clearButtonMode = .whileEditing
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .sentences
            textField.placeholder = placeholder
            textField.borderStyle = .none
            textField.keyboardAppearance = .light
            textField.text = initialText
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        let doneAction = UIAlertAction(title: doneTitle, style: .default) { [unowned alert] action in
            doneHandler(alert.textFields?.first?.text ?? "")
        }
        alert.addAction(doneAction)
        alert.preferredAction = doneAction
        DispatchQueue.main.async {
            (parent ?? UIViewController.current!).present(alert, animated: true)
        }
    }
}

public typealias Alert = UIAlertController

public extension Alert {
    static func show(error: Error, onOK: (() -> Void)? = nil) {
        let alert = Alert(error: error)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            onOK?()
        }))
        alert.show()
    }

    static func show(text: String, onOK: (() -> Void)? = nil) {
        let alert = Alert(alert: text)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            onOK?()
        }))

        alert.show()
    }

    static func show(text: String, title: String, onOK: (() -> Void)? = nil) {
        let alert = Alert(alert: text, title: title)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            onOK?()
        }))

        alert.show()
    }

    static func show(text: String, title: String, okText: String, onOK: (() -> Void)? = nil) {
        let alert = Alert(alert: text, title: title)
        alert.addAction(UIAlertAction(title: okText, style: .default, handler: { (_) in
            onOK?()
        }))

        alert.show()
    }
}

public extension UIAlertController {

    convenience init(alert: String?,
                     preferredStyle: UIAlertController.Style = .alert,
                     actions: String ...) {
        self.init(title: nil,
                  message: alert,
                  preferredStyle: preferredStyle)

        actions.forEach { self.addAction(UIAlertAction(title: $0,
                                                       style: .default)) }
    }

    convenience init(alert: String?, title: String?,
                     preferredStyle: UIAlertController.Style = .alert,
                     actions: String ...) {
        self.init(title: title,
                  message: alert,
                  preferredStyle: preferredStyle)

        actions.forEach { self.addAction(UIAlertAction(title: $0,
                                                       style: .default)) }
    }

    convenience init(error: Error?) {
        let alert: String?

        alert = error?.localizedDescription

        self.init(alert: alert, title: "")
    }

    func show() {
        if let controller = topController() {
            controller.present(self, animated: true)
        }
    }

    @discardableResult func addAction(title: String?,
                                      style: UIAlertAction.Style = .default,
                                      handler: ((UIAlertAction) -> Void)? = nil) -> Alert {
        self.addAction(UIAlertAction(title: title,
                                     style: style,
                                     handler: handler))
        return self
    }

    func addTextField() -> Alert {
        self.addTextField(configurationHandler: nil)
        return self
    }
}

private func topController(base: UIViewController? = UIApplication.shared.activeWindow?.rootViewController) -> UIViewController? {
    guard let next = (base as? UINavigationController)?.visibleViewController
            ?? (base as? UITabBarController)?.selectedViewController
            ?? base?.presentedViewController else { return base }
    return topController(base: next)
}

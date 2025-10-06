//
//  UITableViewExtension.swift
//  Avtobot
//

import UIKit

extension UITableView {

    // MARK: - Scrolling

    func scrollToBottom() {
        let indexPath = IndexPath(row: numberOfRows(inSection: numberOfSections-1) - 1, section: numberOfSections - 1)
        if hasRow(at: indexPath) {
            scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    func hasRow(at indexPath: IndexPath) -> Bool {
        indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }

    // MARK: - Type-Safe Cell Registration & Dequeuing

    public func register<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }

    public func register<T: UITableViewCell>(nib type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forCellReuseIdentifier: String(describing: type))
    }

    public func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    // MARK: - Type-Safe Header/Footer Registration & Dequeuing

    public func register<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }

    public func register<T: UITableViewHeaderFooterView>(nib type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }

    public func dequeue<T: UITableViewHeaderFooterView>() -> T {
        dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
    }
}

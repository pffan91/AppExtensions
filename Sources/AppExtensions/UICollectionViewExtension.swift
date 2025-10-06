//
//  UICollectionViewExtension.swift
//  Avtobot
//
//  Type-safe cell and supplementary view registration & dequeuing
//

import UIKit

public enum ReusableViewKind {
    case header
    case footer

    public var key: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionView {

    // MARK: - Type-Safe Cell Registration & Dequeuing

    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: String(describing: type))
    }

    public func register<T: UICollectionViewCell>(nib type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forCellWithReuseIdentifier: String(describing: type))
    }

    public func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    // MARK: - Type-Safe Supplementary View Registration & Dequeuing

    public func register<T: UICollectionReusableView>(_ type: T.Type, of kind: String) {
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: type))
    }

    public func register<T: UICollectionReusableView>(nib type: T.Type, of kind: String) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: type))
    }

    public func dequeue<T: UICollectionReusableView>(of kind: String, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    // MARK: - Reusable-based Dequeuing (Alternative API)

    public func dequeue<Tile: UICollectionViewCell>(_ tile: Tile.Type, for indexPath: IndexPath) -> Tile {
        dequeueReusableCell(withReuseIdentifier: tile.reuseId, for: indexPath) as! Tile
    }

    public func dequeue<Tile: UICollectionReusableView>(
        _ tile: Tile.Type,
        kind: ReusableViewKind,
        for indexPath: IndexPath
    ) -> Tile {
        dequeueReusableSupplementaryView(ofKind: kind.key, withReuseIdentifier: tile.reuseId, for: indexPath) as! Tile
    }

    public func register(_ tile: (UICollectionReusableView).Type, kind: ReusableViewKind) {
        register(tile, forSupplementaryViewOfKind: kind.key, withReuseIdentifier: tile.reuseId)
    }
}

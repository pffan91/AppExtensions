//
//  UIViewExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit

public extension UIView {

    // MARK: - View Hierarchy

    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }

    /// Extension method: Superview of specific type
    func superview<T>(ofType: T.Type) -> T? {
        var view: UIView? = self
        while view != nil {
            if let typedView = view as? T {
                return typedView
            }
            view = view?.superview
        }
        return nil
    }

    /// Extension method: Subview of specific type
    func subview<T>(ofType type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(ofType: type) }.first
    }

    // MARK: - NIB Loading

    private class func with<T: UIView>(nibName: String, owner: Any? = nil) -> T {
        if let nib = UINib(nibName: nibName, bundle: nil)
            .instantiate(withOwner: owner, options: nil)
            .first as? T {
            return nib
        }
        fatalError("nib \(nibName) not found")
    }

    class func nib(_ nibName: String? = nil, owner: Any? = nil) -> Self {
        let nibName = nibName ?? String(describing: self)
        return with(nibName: nibName, owner: owner)
    }

    // MARK: - Debug

    /// Debug border with default red color
    func debugBorder() {
        debugWithRedBorder()
    }

    /// Debug border with red color
    func debugWithRedBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }

    /// Debug border with green color
    func debugWithGreenBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.green.cgColor
    }

    /// Debug border with blue color
    func debugWithBlueBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
    }

    /// Debug border with custom color
    func debugBorderWithColor(_ color: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }

    func setBottomBorder(backgroundColor: UIColor?, bottomBorderColor: UIColor) {
        self.layer.backgroundColor = backgroundColor?.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = bottomBorderColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }

    func setShadow(color: UIColor = .gray, shadowOffset: CGSize = CGSize(width: 0, height: 1.0), shadowOpacity: Float = 0.4, shadowRadius: CGFloat = 3) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }

    // MARK: - Corner Rounding

    func addTopRoundedCorner(radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft, .topRight],
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    /// Apply gradient to view
    func applyGradient(colors: [UIColor], locations: [NSNumber]?) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func addBlurEffect(style: UIBlurEffect.Style = .systemMaterialDark) {
        backgroundColor = .clear
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        blurView.layer.cornerRadius = layer.cornerRadius
        blurView.layer.masksToBounds = layer.masksToBounds

        self.insertSubview(blurView, at: 0)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.constrainToSides()

        if let imageView = (self as? UIButton)?.imageView {
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }

    // MARK: - Keyboard

    /// Hide keyboard
    @objc func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)    // or view.endEditing(true)
    }

    // MARK: - Screenshots

    func snapshot() -> UIImage? {
        if #available(iOS 14, *) {
            let imageData = UIGraphicsImageRenderer(size: bounds.size).jpegData(withCompressionQuality: 0.5) { _ in
                drawHierarchy(in: bounds, afterScreenUpdates: false)
            }
            return UIImage(data: imageData)
        } else {
            return UIGraphicsImageRenderer(size: bounds.size).image { _ in
                drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: false)
            }
        }
    }

    func takeScreenshot(scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    // MARK: - Animation

    /// Shake view horizontally
    /// - Parameters:
    ///   - maxValue: Max *X* value for shake
    ///   - step: Step to generate values
    ///   - duration: Animation duration in seconds
    func shake(maxValue: Int = 15, step: Int = 5, duration: Double = 0.5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration

        var values = [Int]()
        let positiveNumbers = Array(stride(from: maxValue, to: 0, by: -step))
        let negativeNumbers = Array(stride(from: -maxValue, to: 0, by: step))
        for index in 0..<negativeNumbers.count {
            let positiveValue = positiveNumbers[index]
            let negativeValue = negativeNumbers[index]
            values.append(negativeValue)
            values.append(positiveValue)
        }

        values.append(0)
        animation.values = values
        layer.add(animation, forKey: "shake")
    }

    /// Pulse view
    func pulse(duration: TimeInterval = 0.7) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.alpha = 0.3
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                self.alpha = 1
            }
        })
    }

    /// Rotate view 360°
    func rotate(duration: TimeInterval = 0.7, autoreverses: Bool = false) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = .pi * 2.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = 1
        animation.autoreverses = autoreverses
        layer.add(animation, forKey: "rotate")
    }

    /// Flip left
    func flip(duration: TimeInterval = 0.5) {
        UIView.transition(with: self, duration: duration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }

    /// Bounce animation
    func bounce(duration: TimeInterval = 0.5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 1.1, 0.92, 1.05, 0.97, 1.02, 1.0]
        animation.duration = duration
        animation.calculationMode = CAAnimationCalculationMode.cubic    // CAAnimationCalculationMode.cubic
        layer.add(animation, forKey: "bounce")
    }

    /// Tada animation
    func tada(duration: TimeInterval = 0.3, repeatInterval: TimeInterval = 0) {
        let angle = 12 * CGFloat.pi / 180    // radians

        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [(0, 1), (-angle, 1), (angle, 1.05), (-angle, 1.1) ].map {
            CATransform3DScale(CATransform3DMakeRotation($0.0, 0, 0, 1), $0.1, $0.1, 1)
        }
        animation.autoreverses = true
        animation.duration = duration
        animation.calculationMode = CAAnimationCalculationMode.cubic

        if repeatInterval > 0 {
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = repeatInterval + duration * 2    // Animation autoreverse doubles animation cycle time
            animationGroup.repeatCount = .greatestFiniteMagnitude
            animationGroup.animations = [animation]
            layer.add(animationGroup, forKey: "tada")
        } else {
            layer.add(animation, forKey: "tada")
        }
    }

    // MARK: - Snapping

    /// (extension) Center view in superview with layout constraints.
    /// - parameter safeArea: Use superview's safeAreaLayoutGuide to center view (defult is true)
    func centerInSuperview(safeArea: Bool = true) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: safeArea ? superview.safeAreaLayoutGuide.centerXAnchor : superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: safeArea ? superview.safeAreaLayoutGuide.centerYAnchor : superview.centerYAnchor)
        ])
    }

    /// (extension) Adds a view to the end of the receiver’s list of subviews and center it with layout constraints.
    /// - parameter view: Subview
    /// - parameter safeArea: Use receiver's safeAreaLayoutGuide to center addend subview (defult is true)
    func addCenteredSubview(_ view: UIView, safeArea: Bool = true) {
        addSubview(view)
        view.centerInSuperview(safeArea: safeArea)
    }

    /// (extension) Adds a view as subview of parent view and center view with layout constraints.
    /// - parameter view: Parent view
    /// - parameter safeArea: Use parent view's safeAreaLayoutGuide to center addend view (defult is true)
    /// - returns: Added view
    @discardableResult
    func addCenteredTo(_ view: UIView, safeArea: Bool = true) -> Self {
        view.addSubview(self)
        self.centerInSuperview(safeArea: safeArea)
        return self
    }

    func constrainToCenter(offset: CGSize = .zero) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.width),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: -offset.height)
        ])
    }

    func constrainToSide(_ side: UIRectEdge, offset: CGFloat = 0, toSafeArea: Bool = false) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        switch side {
        case .left: leadingAnchor.constraint(equalTo: toSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor, constant: offset).isActive = true
        case .top: topAnchor.constraint(equalTo: toSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor, constant: -offset).isActive = true
        case .right: trailingAnchor.constraint(equalTo: toSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor, constant: -offset).isActive = true
        case .bottom: bottomAnchor.constraint(equalTo: toSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor, constant: offset).isActive = true
        default: break
        }
    }

    /// Constrain with specific margin to superview's safe area sides
    func constrainToSides(margin: CGFloat) {
        constrainToSides(insets: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
    }

    func constrainToSides(insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all, ignoringSafeArea: Bool = false) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.left) {
            leadingAnchor.constraint(equalTo: ignoringSafeArea ? superview.leadingAnchor : superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left).isActive = true
        }
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: ignoringSafeArea ? superview.topAnchor : superview.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.right) {
            trailingAnchor.constraint(equalTo: ignoringSafeArea ? superview.trailingAnchor : superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: ignoringSafeArea ? superview.bottomAnchor : superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom).isActive = true
        }
    }
}

public extension UIView {

    // MARK: - Frame Shortcuts

    var top: CGFloat {
        get {
            return self.frame.minY
        }
        set {
            self.frame = CGRect(x: self.frame.minX, y: newValue, width: self.frame.width, height: self.frame.height)
        }
    }

    var bottom: CGFloat {
        get {
            return self.frame.maxY
        }
        set {
            self.frame = CGRect(x: self.frame.minX, y: newValue - self.frame.height, width: self.frame.width, height: self.frame.height)
        }
    }

    var left: CGFloat {
        get {
            return self.frame.minX
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
        }
    }

    var right: CGFloat {
        get {
            return self.frame.maxX
        }
        set {
            self.frame = CGRect(x: newValue - self.frame.width, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
        }
    }

    var centerY: CGFloat {
        get {
            return self.frame.minY + self.frame.height / 2
        }
        set {
            self.frame = CGRect(x: self.frame.minX, y: newValue - self.frame.height / 2, width: self.frame.width, height: self.frame.height)
        }
    }

    var centerX: CGFloat {
        get {
            return self.frame.minX + self.frame.width / 2
        }
        set {
            self.frame = CGRect(x: newValue - self.frame.width / 2, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
        }
    }

    // MARK: - Safe Area Anchors

    var igLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    var igRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    var igTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    var igBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    var igCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        }
        return self.centerXAnchor
    }
    var igCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        }
        return self.centerYAnchor
    }
    var width: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame.width
        }
        return frame.width
    }
    var height: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame.height
        }
        return frame.height
    }

    // MARK: - Reuse Identifier

    static var reuseId: String { "\(self)".reuseId }
}

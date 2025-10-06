//
//  BundleExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 04/01/2025.
//

import Foundation

public extension Bundle {
    /// Main app version (1.0) - optional variant
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// Build number (68) - optional variant
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

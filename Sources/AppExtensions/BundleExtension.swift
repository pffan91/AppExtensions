//
//  BundleExtension.swift
//  TopDrive
//
//  Created by Vladyslav Semenchenko on 04/01/2025.
//

import Foundation

extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

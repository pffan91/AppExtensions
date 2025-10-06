//
//  File.swift
//  
//
//  Created by Shyngys Kuandyk on 10.08.2023.
//

import Foundation
import UIKit

public extension UIDevice {
    static var demo: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}

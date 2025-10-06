//
//  DateExtension.swift
//  Avtobot
//
//  Created by Vladyslav Semenchenko on 10/27/22.
//  Copyright © 2022 Alexei. All rights reserved.
//

import Foundation

public extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}

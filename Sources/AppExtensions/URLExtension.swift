//
//  File.swift
//  
//
//  Created by Shyngys Kuandyk on 10.08.2023.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: "\(value)")!
    }
}

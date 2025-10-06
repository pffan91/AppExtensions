//
//  File.swift
//  
//
//  Created by Shyngys Kuandyk on 10.08.2023.
//

import Foundation

public extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? ""
    }
    
    func valueOr(_ defaultValue: String) -> String {
        guard let str = self else { return defaultValue }
        return str.isEmpty ? defaultValue : str
    }
}

//
//  ResultExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import Foundation

extension Result where Success == Void {
    static var success: Result { .success(()) }
}

typealias ResultCallback<T> = (Result<T, Error>) -> Void

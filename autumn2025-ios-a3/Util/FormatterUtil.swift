//
//  FormatterUtil.swift
//  autumn2025-ios-a3
//
//  Created by Saab Kovavinthaweewat on 2/5/2025.
//

// FormatterUtil.swift
// autumn2025-ios-a3

import Foundation

struct FormatterUtil {
    static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

